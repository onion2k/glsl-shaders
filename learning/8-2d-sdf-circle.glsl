
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
    return dot(st,st);
  }

  vec2 repeat(vec2 dist) {
    dist = dist - vec2(0.5); //center the pos
    return mod(dist, 0.333) - 0.5 * 0.333;
  }

  void main(void)
  {
      vec2 uv = gl_FragCoord.xy / u_resolution;
           uv.x *= u_resolution.x / u_resolution.y;

      uv = repeat(uv);
      float c1 = max(0.0, circle(uv));

      c1 = aastep(0.025, c1);

      vec3 color = mix(vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0), c1);
      gl_FragColor = vec4(color, 1.0);
  }
