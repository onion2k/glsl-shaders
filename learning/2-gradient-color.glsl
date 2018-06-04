precision mediump float;

uniform vec2 u_resolution;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // Output to screen
    gl_FragColor = vec4(1.0, 1.0, uv.x, 1.0);
}
