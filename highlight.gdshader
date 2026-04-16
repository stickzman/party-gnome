shader_type canvas_item;

uniform float width = 10.0;
uniform vec4 outline_color: source_color = vec4(1.0);

void fragment() {
	float size = width / float(textureSize(TEXTURE, 0).x);

	vec4 color = texture(TEXTURE, UV);
	float alpha = -4.0 * color.a;
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;

	COLOR = vec4(outline_color.rgb, alpha);
}
