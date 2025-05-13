shader_type spatial;
render_mode unshaded;
render_mode cull_front;
uniform sampler2D prev_pass;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


//void fragment() {
  //vec4 currentColor = textureLod(screen_texture, SCREEN_UV, 0.0);
  //ALBEDO = currentColor.rgb * vec3(10.0, 0.0, 0.0);
  //ALPHA = 1.;
//}
void fragment() {
	vec4 currentColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 uv = SCREEN_UV;
    vec3 sampled_rgb = texture(prev_pass, uv).rgb;
	
	// Obtener la posición del vértice en espacio de cámara
    vec3 camera_pos = (VIEW_MATRIX * MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Ajustar límites para normalizar
	vec3 min_bound = vec3(-10.0, -10.0, -10.0);
	vec3 max_bound = vec3(10.0, 10.0, 10.0);

	// Normalizar al rango 0–1 para meterlo en RGB
	vec3 normalized = (camera_pos - min_bound) / (max_bound - min_bound);
	vec3 normalized2 = (sampled_rgb - min_bound) / (max_bound - min_bound);

	// Guardar las coordenadas en el color
	//ALBEDO = (sampled_rgb- normalized);
	//ALBEDO = currentColor.rgb;
	ALBEDO = normalized-currentColor.rgb;
}