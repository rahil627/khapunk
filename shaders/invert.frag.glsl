#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;

uniform sampler2D tex;

out vec4 ColorOutput;

void kore()
{
    vec4 c = texture(tex, texCoord);
    ColorOutput = vec4(vec3(1.0, 1.0, 1.0) - c.rgb, c.a);
}
