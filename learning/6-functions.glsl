  precision mediump float;

  uniform vec2      u_resolution;           // viewport resolution (in pixels)
  uniform float     u_time;                 // shader playback time (in seconds)

  float random(vec2 c){
    return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
  }

  const float interval = 3.0;
  
  void main() {

    vec3 color = vec3(1.0,0.4,0.4);

    // Random number.
    vec2 pos = gl_FragCoord.xy;
    pos *= sin(u_time);
    float r = random(pos);

    // Noise color using random number.
    vec3 noise = vec3(r);
    float noise_intensity = 0.25;

    // Combined colors.
    color = mix(color, noise, noise_intensity);

    gl_FragColor = vec4(color, 1.0);
  }
