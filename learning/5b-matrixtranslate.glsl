precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

// A function that defines a 2d rotation matrix based on an input angle (in radians)
mat2 rot2(float r){
  float c=cos(r), s=sin(r);
  return mat2(c, s, -s, c);
}

void main(void)
{
    // Normalized position again.
    vec2 uv = gl_FragCoord.xy / u_resolution.x;

    // Subtract a vec2 from the position in order to move the center of rotation. In this
    // case we're using the center of the canvas, but that won't work correctly if your
    // canvas isn't square. Fortunately ours is.
    vec2 uvr = (uv - vec2(0.5, 0.5));

    // Take the new coordinates and multiply them by a mat2 (2d matrix) in order to rotate
    // them. This time our rotation angle is based on the time, so we get a rotating effect.
    uvr = uvr * rot2(u_time * 0.1);

    // The same checkerboard as before, but this time using our new rotated and translated vector.
    float cb = floor(uvr.x * 10.0) + floor(uvr.y * 10.0);

    // And again, the same modulous of the cb alpha value as last time.
    gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
}
