shader_type spatial;
render_mode unshaded;
render_mode cull_back;
render_mode skip_vertex_transform;

varying vec3 v;

void vertex() {
	v = VERTEX; // guardo el valor del VERTEX
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).rgb; // Aplico matrices de modelo y vista 
}
void fragment() {
	ALBEDO = v; 
}