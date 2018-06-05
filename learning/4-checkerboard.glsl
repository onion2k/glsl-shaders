  precision mediump float;

  uniform vec2 u_resolution;
  uniform float u_time;

  void main()
  {
      vec2 uv = gl_FragCoord.xy / u_resolution.x;
      
      // floor() is a GLSL built-in function that returns the whole integer (as a float) of an
      // input value. Eg given 1.5 it returns 1.0, or 2.7563 it returns 2.0, and so on. Using
      // this we can interate a value based chunks of normalized coordinates; by multiplying
      // by a constant float of 50.0 the value of cb only changes once every 50 iterations of
      // uv.x and uv.y.
      float cb = floor(uv.x * 50.) + floor(uv.y * 50.);
      
      // mod() is another built-in function. It returns the modulous of an input and a float.
      // This is a bit different to mod() in JavaScript as that takes an int. By using a mod()
      // of 2.0 we can flip the alpha value on and off every time the cb value is divisible by
      // 2.0, which, given the previous floor() calls, is happens every 50 iterations. Conequently
      // we output a checkerboard effect made up of opaque white and transparent white squares. 
      gl_FragColor = vec4(1.,1.,1.,mod(cb, 2.0));
      
      // Note: "transparent white" might sound a bit weird, but it's important to remember that
      // in graphics programming what color something is *can* make a difference even if you don't
      // see it on-screen.
  }
