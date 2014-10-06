#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;
varying vec4 color;

uniform sampler2D tex;
uniform float transition;

void kore()
{
    vec4 c = texture2D(tex, texCoord);
    gl_FragColor = transition > 0.5 ? vec4(color.rgb,1.0-c.a):vec4(color.rgb,c.a) ;
}
