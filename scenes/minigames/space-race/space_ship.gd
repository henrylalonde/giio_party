extends RigidBody2D

@export_range(0, 3) var device: int = 0

@onready var left_thruster_point: Node2D = $LeftThrusterPoint
@onready var right_thruster_point: Node2D = $RightThrusterPoint
const thruster_power: float = 1000.0

@onready var left_smoke: GPUParticles2D = $LeftThrusterPoint/LeftSmoke
@onready var right_smoke: GPUParticles2D = $RightThrusterPoint/RightSmoke


func _ready() -> void:
	left_smoke.emitting = true
	right_smoke.emitting = true
	
	left_smoke.amount_ratio = 0.0
	right_smoke.amount_ratio = 0.0

func _physics_process(delta: float) -> void:
	var left_trigger = Input.get_joy_axis(device, JOY_AXIS_TRIGGER_LEFT)
	var right_trigger = Input.get_joy_axis(device, JOY_AXIS_TRIGGER_RIGHT)
	
	left_smoke.amount_ratio = left_trigger
	right_smoke.amount_ratio = right_trigger
	
	apply_force(left_trigger * thruster_power * global_transform.basis_xform(Vector2.UP), left_thruster_point.global_position - global_position)
	apply_force(right_trigger * thruster_power * global_transform.basis_xform(Vector2.UP), right_thruster_point.global_position - global_position)
	
