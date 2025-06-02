shader_type spatial;
render_mode unshaded;
render_mode cull_back;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;

uniform sampler3D textura3D;
uniform float umbral_densidad = 0.99;

uniform vec3 volume_min;
uniform vec3 volume_size;


float funcion_densidad(vec3 p) {
	vec3 uvw = clamp(p, 0.0, 1.0);
    float d = texture(textura3D, uvw).r;
    return d > 0.6 ? d : 0.0;
}

float funcion_densidad2(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0);
    float d = texture(textura3D, uvw).r;
    if(d > 0.4)
		return d;
	else 
		return 0.0;
	//return d > umbral_densidad ? d : 0.0;
}

//vec3 funcion_color(vec3 p, float densidad) {
    //vec3 base_color = vec3(1.0); // Color base
    //return mix(vec3(0.0), base_color, densidad); // Interpolación según densidad
//}

vec3 funcion_color2(float densidad) {
    if (densidad >= 0.4 && densidad < 0.65) {
        return vec3(1.0, 0.0, 0.0); // Rojo
    } else if (densidad >= 0.65 && densidad <= 0.75) {
        return vec3(0.0, 1.0, 0.0); // Azul 
    } else if (densidad >= 0.75 && densidad <= 1.0) {
        return vec3(1.0); // Blanco
    } else {
        return vec3(0.0, 0.1, 0.0); // Verde
    }
}


void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
    vec4 tex2 = textureLod(viewport_texture2, SCREEN_UV, 0.0); // textura del segundo viewport
	vec3 v = tex.rgb-tex2.rgb; // vector desde Vertex a tex
    float paso = 0.001; // distancia entre pasos
    vec3 p;
	float dis = length(v);// módulo
	vec3 ray_dir = dis > 0.0 ? normalize(v) : vec3(0.0); // dirección

	vec3 final_color = vec3(0.0);
    float alpha = 0.0;
    vec3 color;
	float densidad = 0.0;
	
	ALBEDO = final_color;
	ALPHA = alpha;
	
	for (float t = 0.0; t < dis; t += paso) {	// Recorremos el rayo
        p = tex2.rgb + (ray_dir * t);			// Punto p en el rayo
		
		densidad = funcion_densidad2(p);
		color = funcion_color2(densidad);
		
		final_color += color * densidad * paso;
        alpha += densidad * paso;
    }
	
	ALBEDO = final_color;
    ALPHA = clamp(alpha, 0.0, 1.0);
}

