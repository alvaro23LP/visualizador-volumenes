shader_type spatial;
render_mode unshaded;
render_mode cull_back;

void fragment() {
	// Obtener la posición del vértice en espacio de cámara
    vec3 camera_pos = (VIEW_MATRIX * MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Ajustar límites para normalizar
	vec3 min_bound = vec3(-10.0, -10.0, -10.0);
	vec3 max_bound = vec3(10.0, 10.0, 10.0);

	// Normalizar al rango 0–1 para meterlo en RGB
	vec3 normalized = (camera_pos - min_bound) / (max_bound - min_bound);

	// Guardar las coordenadas en el color
	ALBEDO = normalized;
}