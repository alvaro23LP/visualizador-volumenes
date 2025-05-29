shader_type spatial;
render_mode unshaded;
render_mode cull_back;
uniform sampler2D viewport_texture;
uniform sampler2D viewport_texture2;
uniform sampler3D volume_noise;
uniform vec3 noise_offset;


float funcion_densidad2(vec3 p) {
	p = normalize(p);
    return texture(volume_noise, p+noise_offset).g;
}
vec3 funcion_color(vec3 p, float densidad) {
    // Asume que densidad ya está calculada para p
    // Puedes mapear el valor a un gradiente, aquí como ejemplo tonos cálidos
    vec3 base_color = vec3(0.8, 0.8, 0.8); // naranja
    return mix(vec3(0.0), base_color, densidad); // más denso, más color
}

//float funcion_densidad(vec3 p) {
    //vec3 center = vec3(0.0,0.0,0.0); // Centro de la esfera
    //float radius = 1.5;      // Radio de la esfera
//
    //if (distance(p, center) < radius) {
        //return 1.0;
    //} else {
        //return 0.0;
    //}
//}

void fragment() {
    vec4 tex = textureLod(viewport_texture, SCREEN_UV, 0.0); // textura del primer viewport
    vec4 tex2 = textureLod(viewport_texture2, SCREEN_UV, 0.0); // textura del segundo viewport
	vec3 v = tex.rgb-tex2.rgb; // vector desde Vertex a tex
    float paso = 0.05; // distancia entre pasos
    vec3 p;
	bool hit = false;
	float dis = length(v); // módulo
	vec3 ray_dir = dis > 0.0 ? normalize(v) : vec3(0.0); // dirección

	vec3 color = vec3(0.0);
	float density = 0.0;
	ALBEDO = color;
    ALPHA = density;
	
	vec3 final_color = vec3(0.0);
    float alpha = 0.0;
	
	for (float t = 0.0; t < dis; t += paso) {
        p = tex2.rgb + (ray_dir * t);
       
		//if(density < 0.8)
			//density += funcion_densidad2(p) * paso;
		//
		//color += funcion_color(p,density) * paso * density;
		
		float densidad = funcion_densidad2(p);
        final_color += funcion_color(p, densidad) * densidad * paso;
        alpha += densidad * paso;
        //if (density > 0.5) {
            //hit = true;
            //break;
        //}
    }
	//if (hit) { //pintamos la esfera
        //ALBEDO = vec3(0.0, 0.0, 1.0);
        //ALPHA = 1.0;
    //} else {
        //ALBEDO = vec3(0.2,0.5,0.7);
        //ALPHA = 0.2;
    //}
	//ALBEDO = color;
    //ALPHA =  clamp(density, 0.0, 1.0);
	ALBEDO = final_color;
    ALPHA = clamp(alpha, 0.0, 0.5);
	//ALBEDO = vec3(v);
}

