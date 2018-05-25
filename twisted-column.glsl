
#extension GL_OES_standard_derivatives : enable

#define GRID_SIZE 0.20
#define GRID_LINE_SIZE 1.25

#define GRID_COLOR_1 vec3(0.00, 0.00, 0.00)
#define GRID_COLOR_2 vec3(0.00, 0.90, 0.20)

precision mediump float;

uniform vec2      u_resolution;           // viewport resolution (in pixels)
uniform float     u_time;                 // shader playback time (in seconds)
uniform vec2      u_mouse;                 // shader playback time (in seconds)

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 500.0;
const float EPSILON = 0.0001;
const float HALF_PI = 1.5707;

float sdSphere( vec3 p, float s )
{
    return length(p)-s;
}

float sdBox( vec3 p, vec3 b )
{
    vec3 d = abs(p) - b;
    return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float sdTorus( vec3 p, vec2 t )
{
    return length( vec2(length(p.xz)-t.x,p.y) )-t.y;
}

float sdf_smin(float a, float b, float k)
{
	float res = exp(-k*a) + exp(-k*b);
	return -log(max(0.0001,res)) / k;
}

vec3 opTwist( vec3 p )
{
    float  c = cos(1.5*p.y+1.0);
    float  s = sin(1.5*p.y+1.0);
    mat2   m = mat2(c,-s,s,c);
    return vec3(m*p.xz,p.y);
}

vec2 map( in vec3 pos )
{

    float box = sdBox( opTwist(pos - vec3(0.0,0.0,0.0)), vec3(0.5,0.5,1.5) );

    vec2 res = vec2(
        box
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

        vec2 uv = abs(mod(pos.xy + GRID_SIZE/2.0, GRID_SIZE) - GRID_SIZE/2.0); 
        
        uv /= fwidth(pos.xy);
        
        float gln = min(uv.x, uv.y) / GRID_SIZE;
        
    	col = mix(GRID_COLOR_1, GRID_COLOR_2, 1.0 - smoothstep(0.0, GRID_LINE_SIZE / GRID_SIZE, gln));

		vec3  lig = normalize( vec3(-0.7, 0.1, -0.7) );
        vec3  hal = normalize( lig-rd );
		float amb = clamp( 0.2+0.5*nor.y, 0.0, 1.0 );
        float dif = clamp( dot( nor, lig ), 0.0, 1.0 );
        float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);
        float dom = smoothstep( -0.1, 0.1, ref.y );
        float fre = pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
        
		float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ), 32.0) *
                    dif *
                    (0.01 + 0.50 * pow( clamp(1.0+dot(hal,rd),0.0,1.0), 0.6 ));

		vec3 lin = vec3(0.0);
        lin += 0.30*amb*vec3(0.20,0.20,0.20);
        lin += 0.50*bac*vec3(0.25,0.25,0.25);
        lin += 0.5*fre*vec3(0.5,0.5,0.5);
		col = col * lin;
		col += 50.00*spe*vec3(0.5,0.5,0.50);

    	col = mix( col, vec3(0.8,0.8,0.8), 1.0-exp( -0.0001*t*t*t ) );
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