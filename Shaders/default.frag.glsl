#version 450


#ifdef GL_ES
precision lowp float;
#endif

// Interpolated values from the vertex shaders
in vec3 iVertPosition;

vec3 dir = normalize(vec3(0.5,0.5,1.0));
vec4 ambient = vec4(0.3,0.7,0.3,1.0);

// Values that stay constant for the whole mesh.
out vec4 fragColor;

void main() {


	vec3 normB = normalize(iVertPosition);
	float d = dot(normB, dir);

	fragColor = vec4(d + ambient.rgb,1.0);
	//fragColor = vec4(1.0,0.0,0.0,1.0);
	
}
    