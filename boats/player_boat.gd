extends RigidBody3D

@export var float_force = 1.0
@export var water_drag = 0.05
@export var water_angular_drag = 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var floats = $FloatContainer.get_children()

var hmap:ViewportTexture

const water_height = 0.0
var submerged = false

func _physics_process(delta: float) -> void:
	submerged = false
	var map = hmap.get_image()
	for f in floats:
		var wheight = f.get_water_height(map)
		print(wheight)
		#var depth = water_height - f.global_position.y
		var depth = wheight - f.global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, f.global_position - global_position)
	
	apply_central_force(transform.basis * Vector3.FORWARD * 20)

	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0,20,0))
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0,-20,0))

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
