#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;

uniform sampler2D tex;

out vec4 ColorOutput;

const mat4 mProtanopia = mat4( 0.20 ,  0.99 , -0.19 ,  0.0 ,
                               0.16 ,  0.79 ,  0.04 ,  0.0 ,
                               0.01 , -0.01 ,  1.00 ,  0.0 ,
                               0.0  ,  0.0  ,  0.0  ,  1.0 );

void kore()
{
    ColorOutput = mProtanopia * texture(tex, texCoord);
}
