#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;
in vec4 color;

uniform sampler2D tex;
uniform float transition;

out vec4 ColorOutput;

void kore()
{
    vec4 c = texture(tex, texCoord);
    ColorOutput = transition > 0.5 ? vec4(color.rgb,1.0-c.a):vec4(color.rgb,c.a) ;
}
