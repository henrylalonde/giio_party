extends Node

var device: int

# 2D array with elements [button, function]
var press_buttons: Array

# 2D array with elements [button, press_function, release_function, was_pressed: bool]
var press_release_buttons: Array

# 2D array with elements [button, unction, cooldown, timer]
var press_repeating: Array


func bind_press(button: JoyButton, function: Callable) -> void:
	press_buttons.append([button, function])


func bind_press_release(button: JoyButton, press_function: Callable, release_function: Callable) -> void:
	press_release_buttons.append([button, press_function, release_function, false])


func bind_press_repeating(button: JoyButton, function: Callable, cooldown: float) -> void:
	press_repeating.append([button, function, cooldown, 0.0])


func _process(delta: float) -> void:
	for binding in press_buttons:
		if Input.is_joy_button_pressed(device, binding[0]):
			binding[1].call()
	
	for binding in press_release_buttons:
		if Input.is_joy_button_pressed(device, binding[0]):
			if not binding[3]:
				binding[3] = true
				binding[1].call()
		else:
			if binding[3]:
				binding[2].call()
	
	for binding in press_repeating:
		if Input.is_joy_button_pressed(device, binding[0]):
			if binding[3] <= 0.0:
				binding[3] = binding[2]
				binding[1].call()
			else:
				binding[3] -= delta
		else:
			binding[3] = 0.0
