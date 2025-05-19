shader_type spatial;
render_mode unshaded;
render_mode cull_back;

void fragment() {
	ALBEDO = VERTEX.xyz;
}