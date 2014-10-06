#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;
uniform vec2 resolution;


void kore()
{
    float x = 1.0 / resolution.x;
    float y = 1.0 / resolution.y;

    vec4 color1 = texture2D(tex, texCoord.st + vec2(-x, -y));
    vec4 color2 = texture2D(tex, texCoord.st + vec2(0.0, -y));
    vec4 color3 = texture2D(tex, texCoord.st + vec2(x, -y));

    vec4 color4 = texture2D(tex, texCoord.st + vec2(-x, 0.0));
    vec4 color5 = texture2D(tex, texCoord.st + vec2(0.0, 0.0));
    vec4 color6 = texture2D(tex, texCoord.st + vec2(x, 0.0));

    vec4 color7 = texture2D(tex, texCoord.st + vec2(-x, y));
    vec4 color8 = texture2D(tex, texCoord.st + vec2(0.0, y));
    vec4 color9 = texture2D(tex, texCoord.st + vec2(x, y));
    vec4 avg = color1 + color2 + color3 + color4 + color5 + color6 + color7 + color8 + color9;

    gl_FragColor = avg / 9.0;
}
