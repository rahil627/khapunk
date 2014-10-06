#version 100

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 texCoord;

uniform sampler2D tex;


void kore()
{
     vec4 c = texture2D(tex, texCoord);
    float gray = dot(c.rgb, vec3(0.299, 0.587, 0.114));
    gl_FragColor = vec4(gray, gray, gray, 1.0) * c.a;
}
