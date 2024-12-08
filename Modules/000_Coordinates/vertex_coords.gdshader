shader_type canvas_item;
varying vec2 vxuv;
// The size of the sprite
uniform float divider:hint_range(1.0, 256.0);
uniform float offset:hint_range(0.0, 0.5);
uniform float texture_mix:hint_range(0.0,1.0);

void vertex(){
	vxuv = VERTEX / divider;
	vxuv += offset;
}
void fragment(){
	vec3 color = vec3(vxuv,0.0);
	float opacity = 1.0;
	vec4 colcoords = vec4(color,opacity);
	vec4 tex = texture(TEXTURE, UV);
	COLOR = mix(colcoords,tex,texture_mix);
}