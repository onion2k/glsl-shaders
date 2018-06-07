precision mediump float;

uniform vec2 u_resolution;
uniform sampler2D u_texture;

void main(void)
{
    vec2 uv = gl_FragCoord.xy / u_resolution;
    gl_FragColor = texture2D(u_texture, uv);
}
