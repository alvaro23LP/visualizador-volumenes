shader_type spatial;

uniform float height_scale = 0.5;
uniform sampler2D noise;
uniform sampler2D normalmap;
uniform vec3 albedo_color : source_color = vec3(0.4, 0.4, 0.8); // Color 

varying vec2 tex_position;

void vertex() {
 	tex_position = VERTEX.xz / 2.0 + 0.5;
 	float height = texture(noise, tex_position).x;
 	VERTEX.y += height * height_scale;
}

void fragment() {
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
	ALBEDO = albedo_color;
}