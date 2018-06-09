
  #extension GL_OES_standard_derivatives : enable

  #ifdef GL_ES
  precision mediump float;
  #endif

  uniform float u_time;
  uniform vec2 u_resolution;

  float aastep(float threshold, float value) {
    #ifdef GL_OES_standard_derivatives
      float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
      return smoothstep(threshold-afwidth, threshold+afwidth, value);
    #else
      return step(threshold, value);
    #endif  
  }

  float circle(in vec2 st) {
    vec2 dist = st-vec2(0.5);
    dist = mod(dist, 0.5) - 0.5 * 0.5;
    return dot(dist,dist);
  }

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution;

      float c1 = smoothstep(0.0, 0.25, max(0.0, circle(uv)));

      float shape = 1. - aastep(0.025, c1);

      vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c1);
      gl_FragColor = vec4(color, 1.0);
  }
