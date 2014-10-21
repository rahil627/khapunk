#ifdef GL_ES
	precision mediump float;
#endif

uniform vec4 uDiffuseColor;
uniform vec4 uAmbientColor;
uniform vec4 uSpecularColor;
uniform vec4 uEmissiveColor;

uniform sampler2D tex;

varying vec2 texCoord;
varying vec3 normal;
varying vec3 lightDir;

void main(void)
{
	float NdotL = max(dot(Normal, lightDir), 0.0);
	vec4 diffuse = uDiffuseColor;
	gl_FragColor = uAmbientColor + (texture2D(tex, texCoord) + diffuse) * NdotL;
}
