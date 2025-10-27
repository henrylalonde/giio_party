extends VBoxContainer

@export_range(0, 3) var device: int = 0

@onready var shape_sprite: Sprite2D = $Control/ShapeSprite
@onready var a_sprite: Sprite2D = $Control/PressA
@onready var label: Label = $Label
@onready var palette: ColorPalette = load("res://resources/player_palette.tres")
@onready var shapes: Array[CompressedTexture2D] = [
	load("res://assets/player-markers/circle.svg"),
	load("res://assets/player-markers/triangle.svg"),
	load("res://assets/player-markers/hexagon.svg"),
	load("res://assets/player-markers/square.svg")
]

var joined: bool = false
var color: Color
const hue_change_speed: float = 0.25

var shape_index: int

var a_sprite_scale: Vector2
var a_sprite_scale_multiplier: float = 1.1
var a_was_pressed: bool = false

var default_cooldown: float = 0.2
var cooldowns: Array[float] = [0.0, 0.0]
var cooldown_buttons: Array[int] = [JOY_BUTTON_DPAD_DOWN, JOY_BUTTON_DPAD_UP]
var button_actions: Array[Callable] = [
	func dpad_down(): 
		shape_index = (shape_index + 1) % shapes.size()
		shape_sprite.texture = shapes[shape_index],
	func dpad_up():
		shape_index = (shape_index - 1) % shapes.size()
		shape_sprite.texture = shapes[shape_index]
]

func _ready() -> void:
	label.text = "P%s" % str(device + 1)
	shape_sprite.hide()
	a_sprite.show()
	a_sprite_scale = a_sprite.scale
	
	shape_index = device
	shape_sprite.texture = shapes[shape_index]
	
	color = palette.colors[device]
	shape_sprite.set_instance_shader_parameter("player_color", color)
	

func _process(delta: float) -> void:
	if not joined:
		if Input.is_joy_button_pressed(device, JOY_BUTTON_A):
			if not a_was_pressed:
				a_was_pressed = true
				a_sprite.modulate.a = 255
				a_sprite.scale = a_sprite_scale * a_sprite_scale_multiplier
		else:
			if a_was_pressed:
				join()
			else:
				return
	
	var offset_direction: Vector2
	offset_direction.x = clampf(Input.get_joy_axis(device, JOY_AXIS_LEFT_X) + Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), -1.0, 1.0)
	offset_direction.y = clampf(Input.get_joy_axis(device, JOY_AXIS_LEFT_Y) + Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y), -1.0, 1.0)
	shape_sprite.position = lerp(shape_sprite.position, 50.0 * offset_direction, 50.0 * delta)
	
	if Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_LEFT):
		color.h = fmod(color.h - hue_change_speed * delta, 1.0)
		shape_sprite.set_instance_shader_parameter("player_color", color)
	if Input.is_joy_button_pressed(device, JOY_BUTTON_DPAD_RIGHT):
		color.h = fmod(color.h + hue_change_speed * delta, 1.0)
		shape_sprite.set_instance_shader_parameter("player_color", color)
	
	for i in range(cooldown_buttons.size()):
		if Input.is_joy_button_pressed(device, cooldown_buttons[i]):
			if cooldowns[i] <= 0.0:
				button_actions[i].call()
				cooldowns[i] = default_cooldown
			else:
				cooldowns[i] -= delta
		else:
			cooldowns[i] = 0.0
	
	
func join() -> void:
	a_sprite.hide()
	shape_sprite.show()
	var tween = create_tween()
	tween.tween_property(shape_sprite, "scale", shape_sprite.scale, 0.1).from(Vector2.ZERO)
	Input.start_joy_vibration(device, 0.0, 1.0, 0.3)
	joined = true
	

func unjoin() -> void:
	a_sprite.scale = a_sprite_scale
	shape_sprite.hide()
	a_sprite.show()
	joined = false
	
