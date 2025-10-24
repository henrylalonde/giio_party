extends Button

var embiggening: Vector2 = Vector2(1.2, 1.2)
var sluggishness: float = 0.1

var tween: Tween
var original_scale: Vector2

func _ready() -> void:
	pivot_offset = size / 2
	mouse_entered.connect(embiggen)
	mouse_exited.connect(regular_size)
	focus_entered.connect(embiggen)
	focus_exited.connect(regular_size)
	original_scale = scale
	


func embiggen() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", embiggening, sluggishness)
	


func regular_size() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", original_scale, sluggishness)
