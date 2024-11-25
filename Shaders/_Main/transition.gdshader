shader_type canvas_item; 
uniform float value:hint_range(0.0, 1.0); 
uniform sampler2D tex_a:hint_default_black;  
uniform sampler2D tex_b:hint_default_black; 

void fragment(){
	vec4 a = texture(tex_a, UV); 
	vec4 b = texture(tex_b, UV); 
	COLOR = mix(a,b,value); 
}