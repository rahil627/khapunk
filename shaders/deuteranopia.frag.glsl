#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;


const mat4 mDeuteranopia = mat4( 0.43 ,  0.72 , -0.15 ,  0.0 ,
                                 0.34 ,  0.57 ,  0.09 ,  0.0 ,
                                -0.02 ,  0.03 ,  1.00 ,  0.0 ,
                                 0.0  ,  0.0  ,  0.0  ,  1.0 );
								 
void kore()
{
    gl_FragColor = mDeuteranopia * texture2D(tex, texCoord); 
}
