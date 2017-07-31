#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;

uniform sampler2D tex;
uniform vec2 resolution;
uniform float radius;
uniform float dirx;
uniform float diry;

out vec4 ColorOutput;

void main()
{
    
    vec4 sum = vec4(0.0);
   
    vec2 tc = texCoord;
   
    float blur = radius / resolution.x;

    
    float hstep = dirx;
    float vstep = diry;

    sum += texture(tex, vec2(tc.x - 4.0*blur*hstep, tc.y - 4.0*blur*vstep)) * 0.0162162162;
    sum += texture(tex, vec2(tc.x - 3.0*blur*hstep, tc.y - 3.0*blur*vstep)) * 0.0540540541;
    sum += texture(tex, vec2(tc.x - 2.0*blur*hstep, tc.y - 2.0*blur*vstep)) * 0.1216216216;
    sum += texture(tex, vec2(tc.x - 1.0*blur*hstep, tc.y - 1.0*blur*vstep)) * 0.1945945946;

    sum += texture(tex, vec2(tc.x, tc.y)) * 0.2270270270;

    sum += texture(tex, vec2(tc.x + 1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.1945945946;
    sum += texture(tex, vec2(tc.x + 2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.1216216216;
    sum += texture(tex, vec2(tc.x + 3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.0540540541;
    sum += texture(tex, vec2(tc.x + 4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.0162162162;

    ColorOutput = vec4(sum.rgb, 1.0);
}
