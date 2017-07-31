#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;

uniform sampler2D tex;

out vec4 ColorOutput;

const mat4 mDeuteranopia = mat4( 0.43 ,  0.72 , -0.15 ,  0.0 ,
                                 0.34 ,  0.57 ,  0.09 ,  0.0 ,
                                -0.02 ,  0.03 ,  1.00 ,  0.0 ,
                                 0.0  ,  0.0  ,  0.0  ,  1.0 );
								 
void kore()
{
    ColorOutput = mDeuteranopia * texture(tex, texCoord); 
}
