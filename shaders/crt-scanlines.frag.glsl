#version 100
#ifdef GL_ES
precision mediump float;
#endif

/*
    Old CRT Monitor Effect Fragment Shader.
	http://clemz.io/article-retro-shaders-rayman-legends
*/
uniform sampler2D tex;
uniform float time;
varying vec2 texCoord;

void kore()
{
  vec3 color = texture2D(tex, texCoord).rgb;

  color -= abs(sin(texCoord.y * 100.0 + time * 5.0)) * 0.08; // (1)
  color -= abs(sin(texCoord.y * 300.0 - time * 10.0)) * 0.05; // (2)

  gl_FragColor = vec4(color, 1.0).rgba;
}