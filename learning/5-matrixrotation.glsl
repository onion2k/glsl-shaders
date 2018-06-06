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
    vec2 uv = gl_FragCoord.xy / u_resolution.y;

    // Take the screen space normalized vector and multiply it by a rotation matrix.
    // This rotates around the vector 0,0 which is the bottom left corner of the canvas.
    // We'll look at translation matrixes to move that next.
    vec2 uvr = uv * rot2(u_time);

    // The same checkerboard as before, but this time using our new rotated vector.
    float cb = floor(uvr.x * 10.0) + floor(uvr.y * 10.0);

    // And again, the same modulous of the cb alpha value as last time.
    gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
}
