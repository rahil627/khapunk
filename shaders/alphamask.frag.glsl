#version 120

#ifdef GL_ES
precision mediump float;
#endif


uniform sampler2D tex; 
uniform sampler2D tex2;
uniform float delta; 
uniform float treshold;
varying vec2 texCoord;
varying vec4 color;


float getAlpha(float value, float delta ){

	value += 0.00001;

	float norm = delta / value;
	if(norm < treshold) norm = 0.0;
	return norm;
}

void kore()
{

	vec4 Mask = texture2D(tex2, texCoord);
	vec4 c = texture2D(tex, texCoord);

	float ratio = ((Mask.r + Mask.g + Mask.b)/3.0);
    c *= 1.0-getAlpha(ratio,delta);
 	gl_FragColor = c *color;
}
