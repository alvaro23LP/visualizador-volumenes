shader_type spatial;
render_mode unshaded;
render_mode cull_back;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D viewport_texture;

float funcion_densidad(vec3 p) {
    vec3 center = vec3(0.5,0.5,0.5); // Centro de la esfera
    float radius = 0.5;      // Radio de la esfera

    if (distance(p, center) < radius) {
        return 1.0;
    } else {
        return 0.0;
    }
}

void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
	
    vec3 ray_dir = normalize((tex.rgb-VERTEX.rgb)); // dirección
    float paso = 0.04; // distancia entre pasos
    vec3 p;
	bool hit = false;
	float v = length(tex.rgb-VERTEX.rgb);

	
	for (float t = 0.0; t < v; t += paso) {
        p = VERTEX.rgb + ray_dir * t;

        float density = funcion_densidad(p);

        if (density > 0.5) {
            hit = true;
            break;
        }
    }
	if (hit) {
        ALBEDO = vec3(0.0, 0.0, 1.0);
        ALPHA = 1.0;
    } else {
        ALBEDO = vec3(0.0,0.5,0.7);
        ALPHA = 0.2;
    }
}

