#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec3 vertexPosition;
in vec2 texPosition;
in vec4 vertexColor;

uniform mat4 projectionMatrix;
uniform float flipy;

out vec2 texCoord;
out vec4 color;

void kore() {
	vec4 res = projectionMatrix * vec4(vertexPosition, 1.0);
	res.y *= (flipy < 0.5 ? 1.0:-1.0);
	gl_Position = res;
	texCoord = texPosition;
	color = vertexColor;
}
