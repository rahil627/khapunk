#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;


void kore()
{
    vec4 c = texture2D(tex, texCoord);
    gl_FragColor = vec4(vec3(1.0, 1.0, 1.0) - c.rgb, c.a);
}
