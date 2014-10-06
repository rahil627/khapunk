#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;


const mat4 mTritanopia = mat4( 0.97 ,  0.11 , -0.08 ,  0.0 ,
                               0.02 ,  0.82 ,  0.16 ,  0.0 ,
                              -0.06 ,  0.88 ,  0.18 ,  0.0 ,
                               0.0  ,  0.0  ,  0.0  ,  1.0 );

void kore()
{
    gl_FragColor = mTritanopia * texture2D(tex, texCoord);
}
