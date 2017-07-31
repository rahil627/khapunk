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
    float gray = dot(c.rgb, vec3(0.299, 0.587, 0.114));
    ColorOutput = vec4(gray, gray, gray,  c.a);
}
