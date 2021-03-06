
#extension GL_OES_standard_derivatives : enable

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

float sdf_smin(float a, float b, float k)
{
	float res = exp(-k*a) + exp(-k*b);
	return -log(max(0.0001,res)) / k;
}

vec2 map( in vec3 pos )
{

    float box = sdSphere( pos - vec3(0.0,0.0,0.0), 0.75 );
    float sphere1 = sdSphere( pos - vec3( 0.5 - sin(u_time)*0.25, 0.5 - cos(u_time)*0.25, 0.0), 0.5 );
    float sphere2 = sdSphere( pos - vec3( -0.5 + sin(u_time)*0.25, 0.5 + cos(u_time)*0.25, 0.0), 0.5 );
    float sphere3 = sdSphere( pos - vec3(  0.0, 0.5 - cos(u_time)*0.25, 0.5 - sin(u_time)*0.25), 0.5 );
    float sphere4 = sdSphere( pos - vec3(  0.0, 0.5 + cos(u_time)*0.25, -0.5 + sin(u_time)*0.25), 0.5 );
    float sphere5 = sdSphere( pos - vec3(  0.0 - cos(u_time)*0.25, 0.5 - sin(u_time)*0.25, 0.0), 0.5 );
    float sphere6 = sdSphere( pos - vec3(  0.0 + cos(u_time)*0.25, -0.5 + sin(u_time)*0.25, 0.0), 0.5 );

    float c = sdf_smin(box, sphere1, 8.);
        c = c = sdf_smin(c, sphere2, 8.);
        c = c = sdf_smin(c, sphere3, 8.);
        c = c = sdf_smin(c, sphere4, 8.);
        c = c = sdf_smin(c, sphere5, 8.);
        c = c = sdf_smin(c, sphere6, 8.);

    vec2 res = vec2(
        c
    , 0.5);

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

    if( m>0.0 )
    {
        vec3 pos = ro + t * rd;
        vec3 nor = calcNormal( pos );
        vec3 ref = reflect( rd, nor );

        float r = mod(pos.x, 0.5);

        if (r > 0.25) {
            col = vec3(1.0, 1.0, 0.0);
        } else {
            col = vec3(1.0, 0.0, 0.0);
        }

		vec3  lig = normalize( vec3(-0.7, 0.1, -0.7) );
        vec3  hal = normalize( lig-rd );
		float amb = clamp( 0.2+0.5*nor.y, 0.0, 1.0 );
        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
        float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);
        float dom = smoothstep( -0.1, 0.1, ref.y );
        float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
        
		float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ),32.0)*
                    dif *
                    (0.04 + 0.96*pow( clamp(1.0+dot(hal,rd),0.0,1.0), 5.0 ));

		vec3 lin = vec3(0.0);
        lin += 0.80*amb*vec3(0.40,0.40,0.40);
        lin += 0.50*bac*vec3(0.25,0.25,0.25);
        lin += 0.25*fre*vec3(1.00,1.00,1.00);
		col = col*lin;
		col += 20.00*spe*vec3(1.00,0.90,0.70);

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

    vec3 ro = vec3( -0.5+3.5*cos(0.1*time + 6.0*mo.x), 1.0 + 3.0, 0.5 + 4.0 );
    vec3 ta = vec3( 0.0, 0.0, 0.0 ); 
    mat3 ca = setCamera( ro, ta, 0.0 );
    vec3 rd = ca * normalize( vec3(p.xy,2.0) );

    vec3 col = render( ro, rd );

    col = pow( col, vec3(0.4545) );

    tot += col;

    gl_FragColor = vec4( tot, 1.0 );
}