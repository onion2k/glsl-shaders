#extension GL_OES_standard_derivatives : enable

precision mediump float;

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

// Here we define a rotation matrix. It's a basic 2,2 matrix based on trig.
mat2 rot2(float r){
  float c=cos(r), s=sin(r);
  return mat2(c, s, -s, c);
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

  uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);

  // Move the coordinate system to move the SDF geometry
  uv -= vec2(u_time * 0.1, u_time * 0.1);
  
  // Rotate the entire coordinate system
  uv *= rot2(cos(u_time) * 0.001);
  
  // Our mod based repeating function
  uv  = repeat(uv, vec2(4.0, 4.0));
  
  
  float c2 = circle(uv, 0.1);
  c2 = smoothstep(c2, 0.1, 0.15);
  c2 = step(0.1, c2);

  float c = c2; //max(c1, c2);

  // c = aastep(0.01, c);

  vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c);
  gl_FragColor = vec4(color, 1.0);
}
