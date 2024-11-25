shader_type canvas_item;
uniform sampler2D gradient;
void fragment(){
	COLOR = texture(gradient,UV.yx);
}