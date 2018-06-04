// Set the precision of floats
precision mediump float;

// the main loop
void main()
{
    //gl_FragColor is a predefined variable that's set for each pixel (texel) in the shader. It takes a 4 float componenent vector of r, g, b, a values.
    gl_FragColor = vec4(0., 0.5, 1., 1.);
}
