  precision mediump float;

  uniform vec2 u_resolution;
  uniform float u_time;

  mat2 rot2(float r){
    float c=cos(r), s=sin(r);
    return mat2(c, s, -s, c);
  }

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution.y;

      vec2 uvr = rot2(u_time) * (0.25 - uv);

      float cb = floor(uvr.x * 10.0) + floor(uvr.y * 10.0);

      gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
  }



// 