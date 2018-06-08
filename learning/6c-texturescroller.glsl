
  precision mediump float;

  uniform float u_time;
  uniform vec2 u_resolution;
  uniform sampler2D u_texture;

  void main(void)
  {
    // A normalized position vector yet again
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // By using the time value in the vec2 we add to the position we can scroll a texture.
    // NOTE: Again, this is a simplified example. We should really be adding the delta of the
    // time between the previous and current frames multiplied by a speed factor in order to
    // move the image however far it would have travelled since the last frame in case frames take
    // longer than 1/60th of a second to draw. For a basic shader like this one that's unlikely
    // though.
    uv = uv + vec2(0.0, u_time * 4.0);

    // We then use the displaced position vector to pick a pixel in the image to copy
    gl_FragColor = texture2D(u_texture, uv);
  }
