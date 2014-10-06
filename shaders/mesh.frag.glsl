#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
uniform bool texturing;
uniform bool lighting;

varying vec2 texCoord;
varying vec3 norm;
varying vec4 color;

void kore() {

	if (texturing) {
		gl_FragColor = texture2D(tex, texCoord);
	}
	else {
		gl_FragColor = color;
	}

	if (gl_FragColor.a <= 0.5) discard;
}