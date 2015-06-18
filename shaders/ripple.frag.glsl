#version 110
#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;
uniform float time; // time in seconds
uniform float resolution; // time in seconds
uniform vec2 position;

void kore()
{
  vec2 tc = texCoord.xy;
  vec2 p = -1.0 + 2.0 * tc;
  float len = length(p);
  vec2 uv = tc + (p/len)*cos(len*resolution-time*4.0)*0.03;
  vec3 col = texture2D(tex,uv).xyz;
  gl_FragColor = vec4(col,texture2D(tex,uv).a); 
}