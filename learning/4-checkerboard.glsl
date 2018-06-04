  precision mediump float;

  uniform vec2 u_resolution;

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution.x;
      float cb = floor(uv.x * 50.) + floor(uv.y * 50.);
      gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
  }
