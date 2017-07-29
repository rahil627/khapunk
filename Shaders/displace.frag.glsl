#version 110

varying vec2 texCoord;
uniform sampler2D tex;
uniform sampler2D displace_map;
uniform float maximum;
uniform float time;

void
kore (void)
{
  float time_e      = time * 0.001;

  vec2 uv_t         = vec2(texCoord.s + time_e, texCoord.t + time_e);
  vec4 displace     = texture2D(displace_map, uv_t);
 
  float displace_k  = displace.g * maximum;
  vec2 uv_displaced = vec2(texCoord.x + displace_k,
                           texCoord.y + displace_k);
						   
	vec4 col = texture2D(tex, uv_displaced);
	col.a = texture2D(tex, texCoord).a;
	gl_FragColor = col;
}