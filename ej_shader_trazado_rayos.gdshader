shader_type spatial;
render_mode unshaded;
render_mode cull_back;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D viewport_texture;

void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
	
	vec3 v = tex.rgb-VERTEX.rgb; // vector desde Vertex a tex
	
	float modulo_rayos = length(v); // módulo rayos
	//vec3 rayos = modulo_rayos > 0.0 ? normalize(v) : vec3(0.0); // dirección
	
	//ALBEDO = rayos;
	ALBEDO = vec3(modulo_rayos);
}

