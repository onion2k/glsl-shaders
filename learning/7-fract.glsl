  precision mediump float;

  uniform vec2 u_resolution;

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution;
      float x = fract(sin(gl_FragCoord.y));
      gl_FragColor = vec4(x,x,x,1.0);
  }
