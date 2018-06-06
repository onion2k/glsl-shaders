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
    vec2 uv = gl_FragCoord.xy / u_resolution.x;
    float aspect = u_resolution.y / u_resolution.x;

    vec2 uvr = uv * rot2(u_time * 0.1);

    uvr = (uv - vec2(0.5, 0.5 * aspect)) * rot2(u_time * 0.1);

    // The same checkerboard as before, but this time using our new rotated and translated vector.
    float cb = floor(uvr.x * 10.0) + floor(uvr.y * 10.0);

    // And again, the same modulous of the cb alpha value as last time.
    gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
}
