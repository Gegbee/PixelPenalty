shader_type canvas_item;

uniform float amplitude = 2.0;
uniform float frequency = 12.0;

void vertex() {
	VERTEX.y += sin((UV.x - TIME) * frequency) * UV.x * amplitude;
	VERTEX.x += cos((UV.y - TIME) * frequency) * UV.x * amplitude;
}