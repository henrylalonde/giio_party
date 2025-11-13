shader_type canvas_item;
render_mode unshaded;

instance uniform vec4 player_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
const vec3 magenta = vec3(1.0, 0.0, 1.0);
const float magenta_hue = 300.0 / 360.0;

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

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	vec3 input_color_hsv = rgb2hsv(input_color.rgb);
	vec3 player_color_hsv = rgb2hsv(player_color.rgb);
	float is_magenta = 1.0 - smoothstep(0.0, 0.05, abs(input_color_hsv.x - magenta_hue));
	float magenta_distance = is_magenta * (1.0 - distance(input_color.rgb, magenta));
	
	vec3 target_color = input_color_hsv;
	target_color.x += is_magenta * (player_color_hsv.x - input_color_hsv.x);
	target_color.y += magenta_distance * (player_color_hsv.y - input_color_hsv.y);
	target_color.z += magenta_distance * (player_color_hsv.z - input_color_hsv.z);
	target_color = hsv2rgb(target_color);
	
	COLOR = vec4(target_color, input_color.a);
}
