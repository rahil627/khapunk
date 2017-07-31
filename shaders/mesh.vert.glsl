#version 450

in vec3 vertexPosition;
in vec2 texPosition;
in vec3 normalPosition;
in vec4 vertexColor;

uniform mat4 mvpMatrix;
uniform bool texturing;
uniform bool lighting;

out vec2 texCoord;
out vec3 norm;
out vec4 color;

void kore() {
	gl_Position =  mvpMatrix * vec4(vertexPosition, 1.0);
	
	color = vertexColor;

	//vec4 lightDir = vec4(0.3, 0.3, 0.3, 1.0);
	//vec4 ambient = vec4(0.2, 0.2, 0.2, 1.0);
	//ambient = ambient * color;
	//vec4 diffuse = color;
	//color = ambient + diffuse * dot(lightDir, vec4(normalPosition, 1.0));

	color = vertexColor;
	
	norm = normalPosition;
	texCoord = texPosition;
}