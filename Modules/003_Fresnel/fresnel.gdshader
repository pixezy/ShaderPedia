shader_type spatial;
render_mode depth_prepass_alpha; 
#include "res://pixezy_shaderlib/fresnel.gdshaderinc"
uniform sampler2D _albedo: source_color; 
uniform vec3 fresnel_color:source_color; 
uniform float fresnel_power=1.0; 
uniform float _emission = 1.0; 
uniform float _mixalbedo:hint_range(0.0, 1.0) = 1.0; 

void fragment(){
	float f = fresnel(fresnel_power,NORMAL,VIEW); 
	vec3 a = texture(_albedo, UV).rgb; 
	
	ALBEDO = mix(a,fresnel_color,_mixalbedo); 
	ALPHA = mix(1.0,f,_mixalbedo); 
	vec3 femission = fresnel_color * f * _emission; 
	EMISSION = mix(vec3(0.0),femission,_mixalbedo); 
	
}