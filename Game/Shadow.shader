shader_type canvas_item;

uniform vec4 shadow_color : hint_color = vec4(1.0); 
uniform int amount = 40;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.a != 0.0 && COLOR != vec4(0.0)) {
		COLOR = shadow_color;
	}
//	vec2 grid_uv = round(UV * float(amount)) / float(amount);
	
//	vec4 text = texture(TEXTURE, grid_uv);
//	if (text.a != 0.0 && text != vec4(0.0)) {
//		COLOR = shadow_color;
//	}
}
void vertex() {
	VERTEX.x -= (1.0 - UV.y) * 12.0;
}