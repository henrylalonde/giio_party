shader_type canvas_item;
render_mode unshaded;

instance uniform vec4 player_color: source_color = vec4(1.0);
const vec3 magenta = vec3(1.0, 0.0, 1.0);
const float magenta_hue = 300.0 / 360.0;
const float tolerance = 0.05;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// COLOR is sRGB
// player_color is Linear

void fragment() {
	vec3 input_color_hsv = rgb2hsv(COLOR.rgb);
	vec3 player_color_srgb = pow(player_color.rgb, vec3(1.0/2.2)); // convert linear uniform to srgb
	vec3 player_color_hsv = rgb2hsv(player_color_srgb);
	float is_magenta = 1.0 - step(tolerance, abs(input_color_hsv.x - magenta_hue));
	float magenta_distance = is_magenta * (1.0 - distance(COLOR.rgb, magenta));
	
	vec3 target_color = vec3(
		mix(input_color_hsv.x, player_color_hsv.x, is_magenta),
		mix(input_color_hsv.y, player_color_hsv.y, magenta_distance),
		mix(input_color_hsv.z, player_color_hsv.z, magenta_distance)
	);
	target_color = hsv2rgb(target_color);
	
	COLOR = vec4(target_color, COLOR.a);
}
