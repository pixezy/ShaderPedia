shader_type canvas_item;
render_mode unshaded, blend_premul_alpha;
uniform float x_value:hint_range(0.0, 1.0);
uniform float y_value:hint_range(0.0, 1.0);
uniform bool use_channels;

void fragment(){
	if(use_channels){
		vec3 c = vec3(UV.x * x_value, UV.y*y_value,0.0);
		COLOR = vec4(c,1.0);
	}else{
		float c = max(UV.x*x_value	,UV.y*y_value);
		COLOR = vec4(vec3(c),1.0);
	}
}