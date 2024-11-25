shader_type canvas_item;
uniform float _step:hint_range(0.0, 1.0)=0.5;
uniform float noise_factor:hint_range(0, 1);
uniform sampler2D _noise;
void fragment() {
	float n = texture(_noise,UV).r;
	float c = step(_step+n * noise_factor,UV.y);
	COLOR = vec4(vec3(c),1.0);

}
