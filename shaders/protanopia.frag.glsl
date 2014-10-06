#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;


const mat4 mProtanopia = mat4( 0.20 ,  0.99 , -0.19 ,  0.0 ,
                               0.16 ,  0.79 ,  0.04 ,  0.0 ,
                               0.01 , -0.01 ,  1.00 ,  0.0 ,
                               0.0  ,  0.0  ,  0.0  ,  1.0 );

void kore()
{
    gl_FragColor = mProtanopia * texture2D(tex, texCoord);
}
