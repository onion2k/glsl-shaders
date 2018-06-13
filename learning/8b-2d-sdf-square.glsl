
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

float square(in vec2 st, vec2 dm) {
    // bottom-left
    vec2 bl = step(dm, st);
    float pct = bl.x * bl.y;

    // top-right
    vec2 tr = step(dm,1.0-st);
    pct *= tr.x * tr.y;
    return pct;
}

float circle(in vec2 st, float radius) {
  return length(st) - radius;
}

vec2 repeat(vec2 dist, vec2 size) {
  return mod(dist, size) - 0.5 * size;
}

void main(void)
{
  vec2 uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);

  uv  = repeat(uv, vec2(0.25, 0.25));
  float c = circle(uv, 0.05);

//   uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);
//   uv -= vec2(0.5,0.5);
//   uv  = repeat(uv - vec2(0.125, 0.125), vec2(0.25, 0.25));
//   float c2 = circle(uv, clamp(sin(u_time) * 0.5, 0.025, 0.25));

//   float cc = min(c,c2);

  c = aastep(0.025, c);

  vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c);
  gl_FragColor = vec4(color, 1.0);
}
