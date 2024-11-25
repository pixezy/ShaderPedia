shader_type canvas_item;
uniform float _step:hint_range(0.0, 1.0)=0.5;
void fragment() {
	float c = step(_step,UV.y);
	COLOR = vec4(vec3(c),1.0);
}
