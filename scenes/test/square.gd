extends Sprite2D

func _process(delta: float) -> void:
	scale += Vector2(1.0, 1.0) * 0.01 * delta
