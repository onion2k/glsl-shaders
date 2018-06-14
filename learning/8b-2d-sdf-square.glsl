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

    vec2 bl = step(0.5 - dm / 2.0, st);
    float pct = bl.x * bl.y;

    vec2 tr = step(st, 0.5 + dm / 2.0);
    pct *= tr.x * tr.y;

    return pct;
}

float circle(in vec2 st, float radius) {
  return length(st) - radius;
}

vec2 repeat(vec2 dist, vec2 size) {
  return mod(dist * size, 1.0);
}

void main(void)
{
  vec2 uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);

  uv *= rot2(0.785);
  uv  = repeat(uv, vec2(4.0, 4.0));
  float x = 0.5;
  float y = 0.25 + abs(sin(u_time) * 0.25);
  float c = square(uv, vec2(x, y));

  // uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);
  // // uv *= rot2(0.785);

  // uv -= vec2((u_time * 0.02),(u_time * 0.02));
  // uv  = repeat(uv, vec2(4.0, 4.0));
  // // float l = clamp(sin(u_time) * 2.0, 0.2, 1.0);
  // float c2 = square(uv, vec2(0.2));

  // float cc = max(c,c2);

  c = aastep(0.025, c);

  vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c);
  gl_FragColor = vec4(color, 1.0);
}
