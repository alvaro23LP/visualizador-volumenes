shader_type spatial;
render_mode unshaded;
render_mode cull_front;

void fragment() {
	ALBEDO = VERTEX.xyz;
}