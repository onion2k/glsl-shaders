precision mediump float;

// Defining uniforms

// A uniform in WebGL is an input. They're values that are bound to the GLSL program in the
// WebGL code outside in the JavaScript. There are a few different types that we'll meet in
// later examples, but here we've got a vec2 that's holding the resolution of the display canvas.

uniform vec2 u_resolution;

// Our main loop
void main()
{
    // gl_FragCoord is a vector that holds the fragment coordinates for the iteration of the shader.
    // Eg the texel on the geometry that we're drawing at the moment. In this particular shader we're
    // drawing on a quad that covers the canvas, so we can think of the gl_FragCoord value as pixels
    // on the screen.
    
    // We're taking the current screen pixel in gl_FragCoord and dividing by the total number of pixels
    // in each direction. This gives us a normalized vec2 (eg values for x and y that go from 0 to 1).
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // As we did in the previous shader we're setting the gl_FragColor value for each pixel. This time
    // we're using the normalized vector based on the current pixel in gl_FragCoord, so the color varies
    // according to the y value of the position. This results in a nice gradient.
    gl_FragColor = vec4(1.0, 1.0, uv.y, 1.0);
}
