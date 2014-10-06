#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;
varying vec4 color;

uniform sampler2D tex;
uniform vec2 resolution;
uniform float scale;

void kore()
{
    if (mod(floor(texCoord.y * resolution.y / scale), 2.0) == 0.0)
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
        gl_FragColor = texture2D(tex, texCoord) * color.a;
}
