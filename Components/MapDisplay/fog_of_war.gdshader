shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(1.0);

void fragment() {
	float texture_brightness = texture(TEXTURE, UV).r;

	COLOR.rgb = fog_color.rgb;
	COLOR.a = 1.0 - texture_brightness;
}
