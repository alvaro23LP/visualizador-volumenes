shader_type spatial;
render_mode unshaded;
render_mode cull_front;

void fragment() {
	ALBEDO = VERTEX.rgb;
	//ALBEDO = vec3(1.0, 0.0, 0.0);
}