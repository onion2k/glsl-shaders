
precision mediump float;

uniform vec2      u_resolution;           // viewport resolution (in pixels)
uniform float     u_time;                 // shader playback time (in seconds)
uniform vec2     u_mouse;                 // shader playback time (in seconds)

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 500.0;
const float EPSILON = 0.0001;
const float HALF_PI = 1.5707;

float sdSphere( vec3 p, float s )
{
    return length(p)-s;
}

float udRoundBox( vec3 p, vec3 b, float r )
{
    return length(max(abs(p)-b,0.0))-r;
}

float sdf_smin(float a, float b, float k)
{
	float res = exp(-k*a) + exp(-k*b);
	return -log(max(0.0001,res)) / k;
}

vec2 opU( vec2 d1, vec2 d2 )
{
	return (d1.x<d2.x) ? d1 : d2;
}

vec3 opRep( vec3 p, vec3 c )
{
    return mod(p, c) - (0.5 * c);
}


vec2 map( in vec3 pos )
{

    float box = udRoundBox( pos - vec3(0.0,0.5,0.0), vec3(0.5), 0.01 );
    float sphere1 = sdSphere( pos - vec3( 0.75 - sin(u_time)*0.25, 0.5, 0.0), 0.4 );
    float sphere2 = sdSphere( pos - vec3( -0.75 + sin(u_time)*0.25, 0.5, 0.0), 0.4 );
    float sphere3 = sdSphere( pos - vec3(  0.0, 0.5, 0.75 - sin(u_time)*0.25), 0.4 );
    float sphere4 = sdSphere( pos - vec3(  0.0, 0.5, -0.75 + sin(u_time)*0.25), 0.4 );
    float sphere5 = sdSphere( pos - vec3(  0.0, 1.25 - sin(u_time)*0.25, 0.0), 0.4 );
    float sphere6 = sdSphere( pos - vec3(  0.0, -0.25 + sin(u_time)*0.25, 0.0), 0.4 );

    float c = sdf_smin(box, sphere1, 8.);
        c = c = sdf_smin(c, sphere2, 8.);
        c = c = sdf_smin(c, sphere3, 8.);
        c = c = sdf_smin(c, sphere4, 8.);
        c = c = sdf_smin(c, sphere5, 8.);
        c = c = sdf_smin(c, sphere6, 8.);

    vec2 res = vec2(
        c
    , 0.5);

    // vec2 res = vec2( udRoundBox( opRep( pos - vec3(0.0,0.5,0.0), vec3(1.1,0.0,1.1) ), vec3(0.5), 0.01 ), 0.5);

    // res = opU( res, vec2(sdSphere( pos-vec3( 0.5, 0.5, 0.0), 0.5 ), 0.5 ));
    return res;
}



vec3 calcNormal( in vec3 pos )
{
    vec2 e = vec2(1.0,-1.0)*0.5773*0.0005;
    return normalize( e.xyy*map( pos + e.xyy ).x + 
					  e.yyx*map( pos + e.yyx ).x + 
					  e.yxy*map( pos + e.yxy ).x + 
					  e.xxx*map( pos + e.xxx ).x );

}


vec2 castRay( in vec3 ro, in vec3 rd )
{
    float tmin = 1.0;
    float tmax = 20.0;
   
#if 0
    // bounding volume
    float tp1 = (0.0-ro.y)/rd.y; if( tp1>0.0 ) tmax = min( tmax, tp1 );
    float tp2 = (1.6-ro.y)/rd.y; if( tp2>0.0 ) { if( ro.y>1.6 ) tmin = max( tmin, tp2 );
                                                 else           tmax = min( tmax, tp2 ); }
#endif
    
    float t = tmin;
    float m = -1.0;
    for( int i=0; i<64; i++ )
    {
	    float precis = 0.0005*t;
	    vec2 res = map( ro+rd*t );
        if( res.x<precis || t>tmax ) break;
        t += res.x;
	    m = res.y;
    }

    if( t>tmax ) m=-1.0;
    return vec2( t, m );
}


vec3 render( in vec3 ro, in vec3 rd )
{ 
    vec3 col = vec3(0.7, 0.9, 1.0) + rd.y * 0.8;
    vec2 res = castRay(ro, rd);
    float t = res.x;
	float m = res.y;

    if( m>-0.5 )
    {
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal( pos );
        vec3 ref = reflect( rd, nor );
        
        // material
		col = 0.45 + 0.35 * sin( vec3(0.75,0.08,0.10) * (m-1.0) );

        // if( m<1.5 )
        // {
        //     float f = 1.0; // checkersGradBox( 5.0*pos.xz );
        //     col = 0.3 + f * vec3(0.1);
        // }

        // lighitng        
        // float occ = calcAO( pos, nor );
		vec3  lig = normalize( vec3(-0.4, 0.7, -0.6) );
        vec3  hal = normalize( lig-rd );
		float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
        float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);
        float dom = smoothstep( -0.1, 0.1, ref.y );
        float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
        
        // dif *= calcSoftshadow( pos, lig, 0.02, 2.5 );
        // dom *= calcSoftshadow( pos, ref, 0.02, 2.5 );

		float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ),16.0)*
                    dif *
                    (0.04 + 0.96*pow( clamp(1.0+dot(hal,rd),0.0,1.0), 5.0 ));

		vec3 lin = vec3(0.0);
        // lin += 1.30*dif*vec3(1.00,0.80,0.55);
        lin += 0.40*amb*vec3(0.40,0.60,1.00);
        // lin += 0.50*dom*vec3(0.40,0.60,1.00)*occ;
        lin += 0.50*bac*vec3(0.25,0.25,0.25);
        lin += 0.25*fre*vec3(1.00,1.00,1.00);
		col = col*lin;
		col += 10.00*spe*vec3(1.00,0.90,0.70);

    	col = mix( col, vec3(0.8,0.9,1.0), 1.0-exp( -0.0002*t*t*t ) );
    }

	return vec3( clamp(col,0.0,1.0) );
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

void main() {
    vec2 mo = u_mouse.xy/u_resolution.xy;
	float time = 15.0 + u_time;

    vec3 tot = vec3(0.0);

    vec2 p = (-u_resolution.xy + 2.0*gl_FragCoord.xy)/u_resolution.y;

    // camera (ray origin)
    vec3 ro = vec3( -0.5+3.5*cos(0.1*time + 6.0*mo.x), 1.0 + 3.0, 0.5 + 4.0 );
    vec3 ta = vec3( 0.0, 0.0, 0.0 ); // look at point
    // camera-to-world transformation
    mat3 ca = setCamera( ro, ta, 0.0 );
    // ray direction
    vec3 rd = ca * normalize( vec3(p.xy,2.0) );

    // render	
    vec3 col = render( ro, rd );

    // gamma
    col = pow( col, vec3(0.4545) );

    tot += col;

    gl_FragColor = vec4( tot, 1.0 );
}