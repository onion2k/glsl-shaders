#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

float aastep(float threshold, float value) {
  #ifdef GL_OES_standard_derivatives
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
  #else
    return step(threshold, value);
  #endif  
}

mat2 rot2(float r){
  float c=cos(r), s=sin(r);
  return mat2(c, s, -s, c);
}

float square(in vec2 st, vec2 dm) {

    // Drawing a square is a bit trickier than a circle. We ignore everything
    // outside of the bottom left, then everything outside of the top right.
    // This gives us the rectangular area in the middle.

    vec2 bl = step(0.5 - dm / 2.0, st);
    float pct = bl.x * bl.y;

    vec2 tr = step(st, 0.5 + dm / 2.0);
    pct *= tr.x * tr.y;

    return pct;
}

float circle(in vec2 st, float radius) {
  return length(st - vec2(0.5)) - radius * 0.5;
}

vec2 repeat(vec2 dist, vec2 size) {
  return mod(dist * size, 1.0);
}

void main(void)
{
  vec2 uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);

  uv -= vec2(0.5,0.5);
  uv *= rot2(cos(u_time) * 0.1);
  uv  = repeat(uv, vec2(4.0, 4.0));
  float x = 0.7;
  float y = 0.7; // + (sin(u_time) * 0.2);
  float c = square(uv, vec2(x, y));

  vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c);
  gl_FragColor = vec4(color, 1.0);
}
