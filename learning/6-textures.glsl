precision mediump float;

uniform vec2 u_resolution;

// Here we're using a new kind of uniform - a 2D sampler (aka a texture). The texture itself needs to
// be set up outside of the GLSL code in the JavaScript - that's a whole separate issue because there
// are lots and lots of options for that. Needlesstosay, the texture uniform we're using here is quite
// a simple one. 
uniform sampler2D u_texture;

void main(void)
{
    // Get a normalized vec2 of the position on the canvas
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // We use the texture2D() built-in function to get the color of a pixel in the texture. It takes a
    // normalized vec2 for the position, so we can just put in the position vector we calculated. This
    // isn't really ideal as it ignores the aspect ratio of the texture - as a rule WebGL textures are
    // square because they're expected to be a power of 2 (eg 32x32, 64x64, 256x256 and so on). We should
    // be using the u_resolution vector to work out the proper texture position to copy, but to keep
    // this example simple we're not.
    // texture2D() returns a vec4 rgba value from the input image, so we can just copy it straight to the
    // gl_FragColor output
    gl_FragColor = texture2D(u_texture, uv);
}
