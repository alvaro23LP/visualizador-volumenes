shader_type spatial;
render_mode cull_back;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;
uniform sampler3D textura3D;

uniform float umbral_densidad = 0.4;
uniform float paso = 0.01;
uniform vec3 volume_min;
uniform vec3 volume_size;
uniform float tex_size;

uniform vec4 extra_color_0 : source_color;
uniform vec4 extra_color_1 : source_color;
uniform vec4 extra_color_2 : source_color;

varying vec3 normal_f;

float funcion_densidad(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0);
    float d = texture(textura3D, uvw).r;
	return d > umbral_densidad ? d : 0.0;
}

vec4 funcion_color(float d) {
    if (d >= 0.3 && d < 0.4) {
        return vec4(extra_color_0.xyz, clamp(extra_color_0.a/25.0, 0.0, 0.3));
    } else if (d >= 0.4 && d <= 0.6) {
        return vec4(extra_color_1.xyz, clamp(extra_color_1.a/25.0, 0.0, 0.3)); 
    } else if (d >= 0.6 && d <= 1.0) {
        return vec4(extra_color_2.xyz,clamp(extra_color_2.a/25.0, 0.0, 0.3)); 
    } else {
        return vec4(0.0); // Vacio 
    }
}

vec3 calcular_normal_volumen(vec3 p) {
	vec3 uvw = clamp((p - volume_min) / volume_size, 0.0, 1.0); //valor de p
	float aux = 1.0/tex_size; // si mi textura es 512^3, aux = 1/512
	
	vec3 uvwX = uvw - vec3(aux, 0., 0.);
	vec3 uvwY = uvw - vec3(0., aux, 0.);
	vec3 uvwZ = uvw - vec3(0., 0., aux);
	
	float a = (texture(textura3D, uvw).r + texture(textura3D, uvw).g + texture(textura3D, uvw).b) / 3.0; 
	
	float bx = (texture(textura3D, uvwX).r + texture(textura3D, uvwX).g + texture(textura3D, uvwX).b) / 3.0;  
	float by = (texture(textura3D, uvwY).r + texture(textura3D, uvwY).g + texture(textura3D, uvwY).b) / 3.0;  
	float bz = (texture(textura3D, uvwZ).r + texture(textura3D, uvwZ).g + texture(textura3D, uvwZ).b) / 3.0;  
		
	float dx = a-bx;
	float dy = a-by;
	float dz = a-bz;

	vec3 normal = vec3(dx, dy, dz);
	return normalize(normal);
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

		alpha = funcion_densidad(p);
		color = funcion_color(alpha);

		final_color += color.rgb * color.a;	
        transparencia += color.a;
		
		if(transparencia > 0.99)
			break;
    }
	
	//Calculo la normal
	normal_f = calcular_normal_volumen(p);
	
	NORMAL = normal_f;
	
	ALBEDO = final_color;
    //ALBEDO = normal_f * 0.5 + 0.5;
    //ALBEDO = normal_f;
    ALPHA = clamp(transparencia, 0.0, 1.0);
}

//void light(){
	//float NdotL = clamp(dot(normal_f, LIGHT), 0.0, 1.0);
	//DIFFUSE_LIGHT +=  NdotL * ATTENUATION * LIGHT_COLOR ;
//}
