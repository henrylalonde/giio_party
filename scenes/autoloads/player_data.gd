class_name PlayerData
extends Resource

@export var joined: bool = false
@export var color: Color = Color.WHITE
@export var shape: CompressedTexture2D = load("res://assets/player-markers/circle.svg")
@export var device: int = 0
@export var score: int = 0
