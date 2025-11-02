extends Control

var main_menu: PackedScene = load("res://scenes/menus/main_menu.tscn")
var lobby_player: PackedScene = load("res://scenes/menus/local-menu/lobby_player.tscn")

@onready var player_container: HBoxContainer = $HBoxContainer

var players: Array[LobbyPlayer]

func _ready() -> void:
	var num_players = 4
	players.resize(4)
	for i in range(4):
		var new_player: LobbyPlayer = lobby_player.instantiate()
		new_player.device = i
		new_player.join_status_changed.connect(_on_join_status_changed)
		players[i] = new_player
		player_container.add_child(new_player)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)	



func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected == false:
		players[device].unjoin()


func _on_join_status_changed() -> void:
	# check how many players are joined and display exit and start buttons accordingly
	pass
