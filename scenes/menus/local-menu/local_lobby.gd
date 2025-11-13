extends Control

var main_menu: PackedScene = load("res://scenes/menus/main_menu.tscn")
var game_scene: PackedScene = load("res://scenes/minigames/space-race/space_race.tscn")
var lobby_player: PackedScene = load("res://scenes/menus/local-menu/lobby_player.tscn")

@onready var player_container: HBoxContainer = $HBoxContainer
@onready var back_button: Button = $BackButton
@onready var start_button: Button = $StartButton

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
	
	back_button.pressed.connect(exit_to_main_menu)
	start_button.pressed.connect(start_game)



func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected == false:
		players[device].unjoin()


func _on_join_status_changed() -> void:
	# check how many players are joined and display exit and start buttons accordingly
	pass



func start_game() -> void:
	var player_count: int = 0
	for player in players:
		var id = player.device
		if not player.joined:
			PlayerSheet.players[id].joined = false
			continue
		PlayerSheet.players[id].joined = true
		PlayerSheet.players[id].color = player.color
		PlayerSheet.players[id].shape = player.shape
		PlayerSheet.players[id].device = id
		PlayerSheet.players[id].score = 0
		player_count += 1
	
	if player_count < 2:
		print("You can't play with only " + str(player_count) + " players!")
	else:
		print("Game Started")
		get_tree().change_scene_to_packed(game_scene)
	

func exit_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)
