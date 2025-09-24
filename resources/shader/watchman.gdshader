shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture;
void fragment() {
	ALBEDO = texture(screen_texture, vec2(-UV.x, -UV.y)).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
