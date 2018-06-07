precision mediump float;

// Our input uniforms. These are standard for most shaders.
uniform vec2      u_resolution;
uniform float     u_time;

// GLSL allows us to define our own functions. The expected output, and each
// input, has to be typed, and we can't mix types (just like any other GLSL code
// really.
// In this particular function we're generating a random number based on a vec2
// of the frag coords. This is only pseudo-randomness, but it works well enough for
// most shaders and it's quick. If you're interested in where it came from there's
// a short history here: https://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
float random(vec2 c){
  return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
  
void main() {

  // First we define a base vec3 rgb color of white. 
  vec3 color = vec3(1.0);

  // Take the fragment position, multiply it by the sine of the current time value, and pass
  // that in to our random() function defined above.
  vec2 pos = gl_FragCoord.xy;
       pos *= sin(u_time);
  float r = random(pos);

  // An arbitrary number to use in a mix() call later to tell the shader how much noise to
  // apply to a given pixel.
  float noise_intensity = 0.5;

  // We use the random number as the three components of a vec3 that defines the noise in
  // each channel.
  vec3 noise = vec3(r);

  // Now we bring the color vec3 and the noise vec3 together using GLSL's mix() built-in function.
  // mix() interpelates between one value and another value according to a weight in the third input.
  color = mix(color, noise, noise_intensity);

  // Take the color vec3 and an opaque alpha value and use them as the pixel color
  gl_FragColor = vec4(color, 1.0);

}
