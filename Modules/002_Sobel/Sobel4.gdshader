shader_type canvas_item;
#include "res://pixezy_shaderlib/sobel_4.gdshaderinc"
uniform float sobel_value:hint_range(0.0, 1.0);
void fragment(){
	vec4 tex = texture(TEXTURE,UV);
	vec3 sbl4 = sobel4(UV,TEXTURE,TEXTURE_PIXEL_SIZE);
	vec3 sobelmix = mix(tex.rgb,sbl4,sobel_value);
	COLOR = vec4(vec3(sobelmix),tex.a);

}