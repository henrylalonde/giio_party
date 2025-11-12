extends Node
class_name ControllerButtons

var device: int



var press_buttons: Dictionary[JoyButton, Callable]

func bind_press(button: JoyButton, function: Callable) -> void:
	press_buttons[button] = function

func unbind_press(button: JoyButton) -> bool:
	var result: bool = press_buttons.erase(button)
	return result


enum JustPress {FUNCTION, WAS_PRESSED}
var just_press_buttons: Dictionary[JoyButton, Dictionary]

func bind_just_press(button: JoyButton, function: Callable) -> void:
	just_press_buttons[button] = {
		JustPress.FUNCTION: function,
		JustPress.WAS_PRESSED: false
	}

func unbind_just_press(button: JoyButton) -> bool:
	var result: bool = just_press_buttons.erase(button)
	return result


enum PressRelease {PRESS_FUNCTION, RELEASE_FUNCTION, WAS_PRESSED}
var press_release_buttons: Dictionary[JoyButton, Dictionary]

func bind_press_release(button: JoyButton, press_function: Callable, release_function: Callable) -> void:
	press_release_buttons[button] = {
		PressRelease.PRESS_FUNCTION: press_function,
		PressRelease.RELEASE_FUNCTION: release_function,
		PressRelease.WAS_PRESSED: false
	}

func unbind_press_release(button: JoyButton) -> bool:
	var result: bool = press_release_buttons.erase(button)
	return result



enum PressRepeat {REPEAT_FUNCTION, COOLDOWN, HOLD_TIMER}
var press_repeat_buttons: Dictionary[JoyButton, Dictionary]

func bind_press_repeat(button: JoyButton, function: Callable, cooldown: float) -> void:
	press_repeat_buttons[button] = {
		PressRepeat.REPEAT_FUNCTION: function,
		PressRepeat.COOLDOWN: cooldown,
		PressRepeat.HOLD_TIMER: 0.0
	}

func unbind_press_repeating(button: JoyButton) -> bool:
	var result: bool = press_repeat_buttons.erase(button)
	return result



func _process(delta: float) -> void:
	for button in press_buttons:
		if Input.is_joy_button_pressed(device, button):
			press_buttons[button].call(delta)
	
	for button in just_press_buttons:
		var params = just_press_buttons[button]
		if Input.is_joy_button_pressed(device, button):
			if not params[JustPress.WAS_PRESSED]:
				params[JustPress.WAS_PRESSED] = true
				params[JustPress.FUNCTION].call()
		else:
			params[JustPress.WAS_PRESSED] = false
	
	for button in press_release_buttons:
		var params = press_release_buttons[button]
		if Input.is_joy_button_pressed(device, button):
			if not params[PressRelease.WAS_PRESSED]:
				params[PressRelease.WAS_PRESSED] = true
				params[PressRelease.PRESS_FUNCTION].call()
		else:
			if params[PressRelease.WAS_PRESSED]:
				params[PressRelease.WAS_PRESSED] = false
				params[PressRelease.RELEASE_FUNCTION].call()
	
	for button in press_repeat_buttons:
		var params = press_repeat_buttons[button]
		if Input.is_joy_button_pressed(device, button):
			if params[PressRepeat.HOLD_TIMER] <= 0.0:
				params[PressRepeat.HOLD_TIMER] = params[PressRepeat.COOLDOWN]
				params[PressRepeat.REPEAT_FUNCTION].call()
			else:
				params[PressRepeat.HOLD_TIMER] -= delta
		else:
			params[PressRepeat.HOLD_TIMER] = 0.0
