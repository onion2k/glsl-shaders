  precision mediump float;

  uniform vec2      u_resolution;
  uniform float     u_time;

  float random(vec2 c){
    return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
  }
  
  void main() {

    vec3 color = vec3(1.0);

    // Random number.
    vec2 pos = gl_FragCoord.xy;
         pos *= sin(u_time);
    float r = random(pos);

    // Noise color using random number.
    vec3 noise = vec3(r);
    float noise_intensity = 0.5;

    color = mix(color, noise, noise_intensity);

    gl_FragColor = vec4(color, 1.0);
  }
