// Set the precision of floats
precision mediump float;

// the main loop

// The main loop is where everything happens. It's called once for every pixel in 
// the shader. These calls effectively run in parallel, so it's really fast, but 
// because of this parallelism there are some differences to how you write things.
// More of that in later examples (because we can happily ignore it for now).

void main()
{
    // gl_FragColor is a predefined variable that's set for each pixel (texel) in
    // the shader. It takes a 4 float componenent vector of r, g, b, a values.

    // Here we're setting the gl_FragColor value to 0 blue, 1/2 red, 1 green, and
    // 1 alpha. Note that in GLSL you need to specify the difference between an INT
    // and a float - rather than 0 for the red value we're using 0. (with a decimal point).
    // We could use 0.0 instead. Types are very important in GLSL.

    gl_FragColor = vec4(0., 0.5, 1., 1.);

}
