#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
uniform bool texturing;
uniform bool lighting;

in vec2 texCoord;
in vec3 norm;
in vec4 color;

out vec4 ColorOutput;

void kore() {

	if (texturing) {
		ColorOutput = texture(tex, texCoord);
	}
	else {
		ColorOutput = color;
	}

	//if (gl_FragColor.a <= 0.5) discard;
}