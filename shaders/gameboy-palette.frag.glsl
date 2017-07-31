#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec2 texCoord;
uniform sampler2D tex;

out vec4 ColorOutput;

/*
    Game Boy Palette Mapping Fragment Shader.
*/


void kore()
{
  vec3 color = texture(tex, texCoord).rgb;
  float a = texture(tex, texCoord).a;
  
  float gamma = 1.5;
  color.r = abs(pow(color.r, gamma));
  color.g = abs(pow(color.g, gamma));
  color.b = abs(pow(color.b, gamma));

  vec3 col1 = vec3(0.612, 0.725, 0.086);
  vec3 col2 = vec3(0.549, 0.667, 0.078);
  vec3 col3 = vec3(0.188, 0.392, 0.188);
  vec3 col4 = vec3(0.063, 0.247, 0.063); 

  float dist1 = length(color - col1);
  float dist2 = length(color - col2);
  float dist3 = length(color - col3);
  float dist4 = length(color - col4);

  float d = min(dist1, dist2);
  d = min(d, dist3);
  d = min(d, dist4);

  if (d == dist1) {
    color = col1; 
  }    
  else if (d == dist2) {
    color = col2;
  }    
  else if (d == dist3) {
    color = col3;
  }    
  else {
    color = col4;
  } 

  ColorOutput = vec4(color, a).rgba;
}
