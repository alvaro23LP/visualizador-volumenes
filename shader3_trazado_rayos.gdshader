shader_type spatial;
//render_mode unshaded;
render_mode cull_back;
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;
uniform vec3 ola;

float funcion_densidad(vec3 p) {
    vec3 center = vec3(0.0,0.0,0.0); // Centro de la esfera
    float radius = 1.5;      // Radio de la esfera

    if (distance(p, center) < radius) {
        return 1.0;
    } else {
        return 0.0;
    }
}

void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
    vec4 tex2 = textureLod(viewport_texture2, SCREEN_UV, 0.0); // textura del segundo viewport
	
	vec3 v = tex.rgb-tex2.rgb; // vector desde Vertex a tex
    
    float paso = 0.04; // distancia entre pasos
    vec3 p;
	bool hit = false;
	float dis = length(v); // módulo
	vec3 ray_dir = dis > 0.0 ? normalize(v) : vec3(0.0); // dirección

	
	for (float t = 0.0; t < dis; t += paso) {
        p = tex2.rgb + (ray_dir * t);

        float density = funcion_densidad(p); 

        if (density > 0.5) {
            hit = true;
            break;
        }
    }
	if (hit) { //pintamos la esfera
        ALBEDO = vec3(0.0, 0.0, 1.0);
        ALPHA = 1.0;
    } else {
        ALBEDO = vec3(0.2,0.5,0.7);
        ALPHA = 0.2;
    }
	//ALBEDO = vec3(v);
	//ALBEDO = vec3(0.5);
	//ALBEDO = ola;
}

