precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;

// In this example we're using 2 textures in separate sampler2D uniforms
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;

void main(void)
{
    vec2 uv = gl_FragCoord.xy / u_resolution;

    // To choose which image we want to display we need a bias value that alternates between
    // 0.0 and 1.0. GLSL has a handy clamp() function that takes a float and returns a lower
    // bound value if the input is less than that, and a higher bound value and returns that
    // if the input is higher than that amount. Values in between are just returned as is.
    // In pseudocode that would be;
    // if (a < lower) { return lower; } else if (a > upper) { return upper; } else { return a; }
    float bias = clamp(sin(u_time), 0.0, 1.0);

    // Now we have a bias between 0.0 and 1.0 we can use that value to mix the two texture values
    // for a given coordinate. 0.0 is fully u_texture1, and 1.0 is fully u_texture2.
    gl_FragColor = mix(texture2D(u_texture1, uv), texture2D(u_texture2, uv), bias);
}
