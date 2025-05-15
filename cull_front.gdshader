shader_type spatial;
render_mode unshaded;
render_mode cull_front;

void fragment() {
    vec3 camera_pos = (VIEW_MATRIX * MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec3 min_bound = vec3(-10.0, -10.0, -10.0);
	vec3 max_bound = vec3(10.0, 10.0, 10.0);

	vec3 normalized = (camera_pos - min_bound) / (max_bound - min_bound);

	ALBEDO = normalized;
}