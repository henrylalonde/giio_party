class_name LobbyPlayer
extends VBoxContainer

signal join_status_changed

@export_range(0, 3) var device: int = 0

@onready var controller_buttons: ControllerButtons = $ControllerButtons
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
const HUE_CHANGE_SPEED: float = 0.25

var shape_index: int
var shape_tween: Tween
var shape_sprite_scale: Vector2

var a_sprite_scale: Vector2
var a_sprite_alpha: float
var scale_multiplier: float = 1.1


func dpad_down(): 
	shape_index = (shape_index + 1) % shapes.size()
	shape_sprite.texture = shapes[shape_index]


func dpad_up():
	shape_index = (shape_index - 1) % shapes.size()
	shape_sprite.texture = shapes[shape_index]
	

func dpad_left(delta: float): 
	color.h = fmod(color.h - HUE_CHANGE_SPEED * delta, 1.0)
	shape_sprite.set_instance_shader_parameter("player_color", color)
	

func dpad_right(delta: float):
	color.h = fmod(color.h + HUE_CHANGE_SPEED * delta, 1.0)
	shape_sprite.set_instance_shader_parameter("player_color", color)



func press_a():		
	if joined:
		return
	a_sprite.modulate.a = 255
	a_sprite.scale = a_sprite_scale * scale_multiplier
	


func join() -> void:
	if joined:
		return
	a_sprite.hide()
	shape_sprite.show()
	if shape_tween:
		shape_tween.kill()
	shape_tween = create_tween()
	shape_tween.tween_property(shape_sprite, "scale", shape_sprite_scale, 0.1).from(Vector2.ZERO)
	Input.start_joy_vibration(device, 0.0, 1.0, 0.3)
	joined = true
	join_status_changed.emit()



func unjoin() -> void:
	if not joined:
		return
	a_sprite.scale = a_sprite_scale
	a_sprite.modulate.a = a_sprite_alpha
	if shape_tween:
		shape_tween.kill() 
	shape_tween = create_tween()
	shape_tween.tween_property(shape_sprite, "scale", Vector2.ZERO, 0.1).from_current()
	shape_tween.tween_callback(reset_shape)
	a_sprite.show()
	joined = false
	join_status_changed.emit()
	

func reset_shape():
	shape_sprite.hide()
	shape_index = device
	shape_sprite.texture = shapes[shape_index]
	color = palette.colors[device]
	shape_sprite.set_instance_shader_parameter("player_color", color)


func _ready() -> void:
	label.text = "P%s" % str(device + 1)
	
	a_sprite.show()
	a_sprite_scale = a_sprite.scale
	a_sprite_alpha = a_sprite.modulate.a
	
	shape_sprite_scale = shape_sprite.scale
	reset_shape()
	
	controller_buttons.device = device
	controller_buttons.bind_press_repeat(JOY_BUTTON_DPAD_DOWN, dpad_down, 0.2)
	controller_buttons.bind_press_repeat(JOY_BUTTON_DPAD_UP, dpad_up, 0.2)
	
	controller_buttons.bind_press(JOY_BUTTON_DPAD_LEFT, dpad_left)
	controller_buttons.bind_press(JOY_BUTTON_DPAD_RIGHT, dpad_right)
	
	controller_buttons.bind_just_press(JOY_BUTTON_B, unjoin)
	
	controller_buttons.bind_press_release(JOY_BUTTON_A, press_a, join)
	


func _process(delta: float) -> void:
	if not joined:
		return
	
	var offset_direction: Vector2
	offset_direction.x = clampf(Input.get_joy_axis(device, JOY_AXIS_LEFT_X) + Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), -1.0, 1.0)
	offset_direction.y = clampf(Input.get_joy_axis(device, JOY_AXIS_LEFT_Y) + Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y), -1.0, 1.0)
	shape_sprite.position = lerp(shape_sprite.position, 50.0 * offset_direction, 50.0 * delta)
	
	
