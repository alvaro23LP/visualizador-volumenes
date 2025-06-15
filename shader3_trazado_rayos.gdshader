shader_type spatial;
render_mode cull_back;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;
uniform sampler3D textura3D;

uniform float umbral_densidad = 0.3;
uniform float paso = 0.001;
uniform vec3 volume_min;
uniform vec3 volume_size;
uniform float tex_size;

uniform sampler3D volume_noise;
uniform vec3 noise_offset;

uniform vec4 extra_color_0 : source_color;
uniform vec4 extra_color_1 : source_color;
uniform vec4 extra_color_2 : source_color;

float funcion_densidad(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0);
    float d = texture(textura3D, uvw).r;
	return d > umbral_densidad ? d : 0.0;
}

float funcion_densidad2(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0);
    float d = texture(volume_noise, uvw+noise_offset).r;
	return d > umbral_densidad ? d : 0.0;
}

vec4 funcion_color(float d) {
    if (d >= 0.3 && d < 0.4) {
        return vec4(extra_color_0.xyz, clamp(extra_color_0.a/35.0, 0.0, 0.3));
    } else if (d >= 0.4 && d <= 0.6) {
        return vec4(extra_color_1.xyz, clamp(extra_color_1.a/35.0, 0.0, 0.3)); 
    } else if (d >= 0.6 && d <= 1.0) {
        return vec4(extra_color_2.xyz,clamp(extra_color_2.a/35.0, 0.0, 0.3)); 
    } else {
        return vec4(0.0); // Vacio 
    }
}

void fragment() {
    vec4 traseras = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
    vec4 delanteras = textureLod(viewport_texture2, SCREEN_UV, 0.0); // textura del segundo viewport
	vec3 v = traseras.rgb-delanteras.rgb; // vector desde delanteras a traseras
    vec3 p;
	float dis = length(v);// módulo
	vec3 ray_dir = dis > 0.0 ? normalize(v) : vec3(0.0); // dirección

	vec3 final_color = vec3(0.0);
    float transparencia = 0.0;
    vec4 color;
	float alpha = 0.0;

	ALBEDO = final_color;
	ALPHA = alpha;

	for (float t = 0.0; t < dis; t += paso) {	// Recorremos el rayo
        p = delanteras.rgb + (ray_dir * t);			// Punto p en el rayo

		alpha = funcion_densidad2(p);
		color = funcion_color(alpha);

		final_color += color.rgb * color.a;	
        transparencia += color.a;
		
		if(transparencia > 0.99)
			break;
    }
	
	ALBEDO = final_color;
    ALPHA = clamp(transparencia, 0.0, 1.0);
}
