  precision mediump float;

  uniform vec2 u_resolution;
  uniform float u_time;

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution.x;
      float cb = floor((0.5 - uv.x + cos(gl_FragCoord.x / u_resolution.x)) * 30.) + floor(( uv.y + sin(gl_FragCoord.x / u_resolution.x)) * 30.);
      gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
  }
