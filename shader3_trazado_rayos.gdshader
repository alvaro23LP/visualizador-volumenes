shader_type spatial;
render_mode unshaded;
render_mode cull_back;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;
uniform sampler3D volume_noise;
uniform vec3 noise_offset;

uniform vec3 volume_min;
uniform vec3 volume_size;

float funcion_densidad(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0);
    float d = texture(volume_noise, uvw+noise_offset).r;
	return d;
}
vec3 funcion_color(vec3 p, float densidad) {
    vec3 base_color = vec3(0.8, 0.8, 0.8); // blanco
    return mix(vec3(0.0), base_color, densidad); // más denso, más color
}

void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
    vec4 tex2 = textureLod(viewport_texture2, SCREEN_UV, 0.0); // textura del segundo viewport
	vec3 v = tex.rgb-tex2.rgb; // vector desde Vertex a tex
    float paso = 0.005; // distancia entre pasos
    vec3 p;
	float dis = length(v); // módulo
	vec3 ray_dir = dis > 0.0 ? normalize(v) : vec3(0.0); // dirección

	vec3 final_color = vec3(0.0);
    float alpha = 0.0;
	float densidad;
	
	ALBEDO = final_color; 
	ALPHA = alpha;
	
	for (float t = 0.0; t < dis; t += paso) {
        p = tex2.rgb + (ray_dir * t);
		
		densidad = funcion_densidad(p);
        final_color += funcion_color(p, densidad) * densidad * paso;
        alpha += densidad * paso;
    }

	ALBEDO = final_color;
    ALPHA = clamp(alpha, 0.0, 0.5);
}

