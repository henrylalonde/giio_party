extends Node2D

@onready var starting_positions: Array[Marker2D] = [
	$StartingPositions/P1,
	$StartingPositions/P2,
	$StartingPositions/P3,
	$StartingPositions/P4
]
var ship_scene: PackedScene = load("res://scenes/minigames/space-race/space_ship.tscn")

func _ready() -> void:
	for player in PlayerSheet.players:
		if not player.joined:
			continue
		var new_ship: SpaceRaceShip = ship_scene.instantiate()
		new_ship.color = player.color
		new_ship.shape = player.shape
		new_ship.device = player.device
		new_ship.global_position = starting_positions[player.device].global_position
		add_child(new_ship)
