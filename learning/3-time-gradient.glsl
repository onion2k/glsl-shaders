
precision mediump float;

// The canvas resolution from the previous example.
uniform vec2 u_resolution;

// A new uniform - a floating point value that holds a time value that accumulates as the
// shader runs. This value is set outside of the shader in the Javascript.
uniform float u_time;

void main()
{
    // Normalized texel coordinates (from 0 to 1). In our quad-based system this is effectively
    // just the screen space coordinates in pixels.
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // This code takes a base float of 0.5 and adds on the result of 0.5 multiplied by the cosign
    // of the time value, a 3 component vector of the screen space (x, y, x), and a constant 3
    // component vector of (0, 2, 4). Adding a float to a vec3 just adds that value to each component.
    // Added another vec3 adds each component to it's corresponding component.
    // What this ultimately results in is a vec3 that varies across the screen, and that varies in
    /// time, which gives a pleasant gradient effect.
    vec3 col = 0.5 + 0.5 * cos(u_time + uv.xyx + vec3(0,2,4));

    // The color vec3 is then used as the first three components of a vec4 (rgba) color. The last
    // component, alpha, is set to a constant float of 1.0 (eg opaque).
    gl_FragColor = vec4(col,1.0);
}
