extends Control

var main_menu: PackedScene = load("res://scenes/menus/main_menu.tscn")

@onready var back_button: Button = $Back
@onready var start_button: Button = $Start

func _ready() -> void:
	start_button.grab_focus()
	back_button.pressed.connect(func (): get_tree().change_scene_to_packed(main_menu))
	
