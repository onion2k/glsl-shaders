# glsl-shaders

Just a bunch of glsl code written in an attempt to understand how webgl shaders work. Most of this is from Shadertoy originally.

# Recording shaders

I use https://github.com/spite/ccapture.js/ to record the canvas to a webm video, and then use ffmpeg to transcode the resulting file to MP4 for sharing. By setting the canvas size you can easily control the input video. Getting ffmpeg's settings right is a bit trickier.

These are the things I've tried so far...

* `ffmpeg -i <in> -c:v libx264 -preset veryslow -crf 10 <out>`
* `ffmpeg -i <in> -c libx264 -movflags faststart -c libx264 <out>`
