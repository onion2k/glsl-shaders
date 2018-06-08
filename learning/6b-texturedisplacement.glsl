
  precision mediump float;

  uniform float u_time;
  uniform vec2 u_resolution;
  uniform sampler2D u_texture;

  void main(void)
  {
    // A normalized position vector yet again
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // We don't have to use the position as is. We can add something to the vector to
    // displace it as we did in the displaced checkerboard in the previous example.
    uv = uv + vec2(0.5 - sin(dot(uv.x, uv.y) * 13.0), 0.0) * (sin(u_time * 0.5) * 0.25);

    // We then use the displaced position vector to pick a pixel in the image to copy
    gl_FragColor = texture2D(u_texture, uv);
  }
