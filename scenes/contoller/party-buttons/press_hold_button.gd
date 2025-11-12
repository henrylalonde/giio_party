extends Button

@export var joy_button_shortcut: JoyButton = JOY_BUTTON_A
@export var joy_press_time: float = 1.0
@export var joy_press_fill: TextureProgressBar.FillMode = TextureProgressBar.FillMode.FILL_LEFT_TO_RIGHT

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

var was_pressed: bool = false
var was_held: bool = false
var hold_timer: float = 0.0

var embiggening: float = 1.2
var sluggishness: float = 0.1

var tween: Tween
var original_scale: Vector2

func _ready() -> void:
	progress_bar.value = 0.0
	progress_bar.texture_progress = icon
	progress_bar.fill_mode = joy_press_fill
		
	mouse_entered.connect(embiggen)
	mouse_exited.connect(regular_size)
	focus_entered.connect(embiggen)
	focus_exited.connect(regular_size)
	original_scale = scale
	

func _process(delta: float) -> void:
	if any_pressed():
		if not was_pressed:
			embiggen()
			hold_timer = 0.0
			progress_bar.value = 0.0
		else:
			hold_timer += delta
			if hold_timer >= joy_press_time:
				progress_bar.value = 1.0
				if not was_held:
					pressed.emit()
				was_held = true
			progress_bar.value = hold_timer / joy_press_time
		was_pressed = true
	else:
		if was_pressed:
			regular_size()
			progress_bar.value = 0.0
			was_pressed = false
			was_held = false



func any_pressed() -> bool:
	if has_focus():
		return false
	for device in Input.get_connected_joypads():
		if Input.is_joy_button_pressed(device, joy_button_shortcut):
			return true
	return false



func embiggen() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", embiggening * original_scale, sluggishness)
	


func regular_size() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", original_scale, sluggishness)
