# glsl-shaders

Just a bunch of glsl code written in an attempt to understand how webgl shaders work. Most of this is from Shadertoy originally.

# Recording shaders

I use https://github.com/spite/ccapture.js/ to record the canvas to a webm video, and then use ffmpeg to transcode the resulting file to MP4 for sharing. By setting the canvas size you can easily control the input video. Getting ffmpeg's settings right is a bit trickier.

These are the things I've tried so far...

* `ffmpeg -i <in> -c:v libx264 -preset veryslow -crf 10 <out>`
* `ffmpeg -i <in> -c libx264 -movflags faststart -c libx264 <out>`

# Shaders

Each of the glsl files in the lib directory is a part of a larger shader, and they won't work on their own. glsl doesn't have any sort of dependency system, so it's a cut'n'paste job to bring in the parts you need. Maybe one day I'll write a system for building them own of templates/lambda functions/whatever.

# Uniforms

These are (mostly) converted to use TWGL.js and it's standard uniforms.

* u_time - float for the currrent time
* u_resolution - vec2 of the screen resolution
* u_mouse - vec2 of the screen space mouse coords
* u_texture - a texture in RGBA as an INT8 array, wrapped and flipped

# Textures

TWGL.js has functions for loading a texture in to a uniform.

```javascript
let imgTex = twgl.createTexture(gl, {
  src: 'https://source.unsplash.com/random/512x512',
  crossOrigin: "",
  mag: gl.NEAREST,
  flipY: true
});
```

The imgText var can then be passed to the shader in the uniforms object. 

# Things to learn

* mix(), min(), max(), etc
* clamp()
* step(), smoothstep()
* Signed distance fields
* Particles (arrays?)
* texture arrays
