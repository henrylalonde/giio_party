extends Node

var players: Array[PlayerData]

const MAX_PLAYERS: int = 4

func _ready() -> void:
	for i in range(MAX_PLAYERS):
		players.append(PlayerData.new())
