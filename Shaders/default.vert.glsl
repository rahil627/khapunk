#version 450


#ifdef GL_ES
precision lowp float;
#endif

// Input vertex data, different for all executions of this shader
in vec3 position;

// Output data: will be interpolated for each fragment.
out vec3 iVertPosition;
// Values that stay constant for the whole mesh
uniform mat4 MVP;


void main() {
  // Just output position
  iVertPosition = position;
  gl_Position =   MVP * vec4(position,1.0);
}