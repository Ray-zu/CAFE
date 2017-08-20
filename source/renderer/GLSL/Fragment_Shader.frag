#version 330
varying vec4 vColor;
varying vec2 uvpos;
uniform sampler2DRect Texsampler;
uniform vec2 sizemag;
void main (void)
{
  gl_FragColor = texture(Texsampler, uvpos*sizemag+0.5);
}