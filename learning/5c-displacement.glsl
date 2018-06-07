precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

void main()
{
    // Generate a normalized vec2 of the screen space coordinates
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // Add a vec2 to the current position in order to move it. We're moving
    // the x value (horizontal) by the cosine of the vertical position multiplied
    // by a constant factor (8.0). This creates a nice wave effect. Then we
    // multiply that by the sine of the current time in order to move it backwards
    // and forwards
    // When you want to create a displacement effect you'll usually be adding
    // something to the current normalized position.
    uv = uv + vec2(cos(uv.y * 8.0), 0.0) * (sin(u_time) * 0.05);

    // The checkerboard algorithm again.
    float cb = floor(uv.x*25.) + floor(uv.y*25.);

    // Set the opactity of every other square
    gl_FragColor = vec4(1.0, 1.0, 1.0,mod(cb, 2.0));
}

