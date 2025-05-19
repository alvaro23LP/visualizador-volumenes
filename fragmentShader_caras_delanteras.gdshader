shader_type spatial;
render_mode unshaded;
render_mode cull_back;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D viewport_texture;

void fragment() {
	//vec4 currentColor = textureLod(screen_texture, SCREEN_UV, 0.0);
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0);

	//ALBEDO = VERTEX.rbg-tex.rgb;
	
	for(float i=1.0; i<600.0 ; i++){
		vec3 p = VERTEX.rgb + VERTEX.rbg-tex.rgb * vec3(i);
		if(p == vec3(0.25)){
			ALBEDO = vec3(1.0,0.0,0.0);
			ALPHA = 1.0;
		} else {
			ALPHA = 0.0;
		}
	}
	
}