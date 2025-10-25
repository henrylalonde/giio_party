extends Control

var local_lobby: PackedScene = load("res://scenes/menus/local-menu/local_lobby.tscn")

@onready var play_button: Button = $Play
@onready var settings_button: Button = $Settings
@onready var exit_button: Button = $Exit

func _ready() -> void:
	play_button.grab_focus()
	play_button.pressed.connect(func (): get_tree().change_scene_to_packed(local_lobby))
	exit_button.pressed.connect(get_tree().quit)
