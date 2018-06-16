// The dFdx and dFdy functions used by aastep need this switched on
#extension GL_OES_standard_derivatives : enable

// Set the float precision
precision mediump float;

// Our two standard input uniforms
uniform float u_time;
uniform vec2 u_resolution;

// This function returns a float but anti-aliased to a threshold.
float aastep(float threshold, float value) {
  #ifdef GL_OES_standard_derivatives
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
  #else
    return step(threshold, value);
  #endif  
}

// This is an signed distance field function. It takes a point on the canvas and returns 
// a value based on whether or not the point is inside or outside of our shape. The circle
// is the simplest SDF function, but there are plenty of others.
// SDF functions can be used for 3D shapes too. More on that later.
float circle(in vec2 st, float radius) {
  return length(st - 0.5) - radius;
}

// One of the brilliant things about SDF functions is that they work on a normalized space
// (eg 0.0 to 1.0). Because of this we can break our canvas in to multiple fields using mod(),
// which is a very cheap way to repeat a shape.
vec2 repeat(vec2 dist, vec2 size) {
  return mod(dist * size, 1.0);
}

void main(void)
{
  vec2 uv = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);

  // This is a call to the repeating function. One slightly odd thing about SDF functions
  // is that technically you don't repeat the shape itself; you make the entire space a
  // repeating value. 
  uv  = repeat(uv, vec2(0.25, 0.25));
  
  // Using our repeating geometry space we then determine which points are inside the circle
  // and which are outside.
  float c = circle(uv, 0.05);

  // Then we pass the point value to the anti-aliasing function so it's lovely and smooth
  c = aastep(0.025, c);

  // Lastly we use the point value to determine a value for the color
  vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c);
  gl_FragColor = vec4(color, 1.0);
}
