shader_type canvas_item;
render_mode unshaded;

instance uniform vec4 player_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
const vec3 magenta = vec3(1.0, 0.0, 1.0);
const float tolerance = 0.01;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	float is_magenta = 1.0 - distance(input_color.rgb, magenta);
	vec3 modified_color = mix(input_color.rgb, player_color.rgb, is_magenta);
	COLOR = vec4(modified_color, input_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
