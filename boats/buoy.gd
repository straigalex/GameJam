extends RigidBody3D

# Buoy
@export var float_force = 1.0
@export var water_drag = 0.05
@export var water_angular_drag = 0.05
@export var player_node = null

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var confetti_particles = preload("res://assets/confetti_particle.tscn").instantiate()

const water_height = 0.0
var submerged = false

# Colouring
@onready var buoy_mesh = %BuoyModel/Sphere

const active_color := Color8(0,255,0) # Green
const next_color := Color8(255,255,0) # Yellow
const other_color := Color8(100,100,100) # Grey

# Checkpoint
enum buoy_directions {
	PORT_SIDE,
	STARBOARD_SIDE
}

signal buoy_entered(buoy_node: RigidBody3D, index: int)

@export var checkpoint_position = -1
@export var required_direction = buoy_directions.PORT_SIDE

@onready var checkpoint = %CheckpointArea
@onready var label = $Label3D


func _ready() -> void:
	label.text = str(checkpoint_position)
	if required_direction == buoy_directions.PORT_SIDE:
		%Arrow.rotate_x(PI)
	updade_checkpoint_color(1)

func _process(delta: float) -> void:
	if required_direction == buoy_directions.PORT_SIDE:
		%Arrow.rotate_y(PI/2 * delta)
	else:
		%Arrow.rotate_y(-PI/2 * delta)

func _physics_process(delta: float) -> void:
	var depth = water_height - global_position.y
	submerged = false
	if depth > 0:
		submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag


func is_correct_side(boat_position: Vector3, boat_forward: Vector3) -> bool:
	# Based on heading when boat enters
	var buoy_vector = (global_position - boat_position).normalized()

	var side = boat_forward.cross(buoy_vector).dot(Vector3.UP)

	if required_direction == buoy_directions.PORT_SIDE:
		return side > 0
	elif required_direction == buoy_directions.STARBOARD_SIDE:
		return side < 0
	
	push_error("is_correct_side side not set")
	return false

func updade_checkpoint_color(current_checkpoint: int) -> void:
	var mat : StandardMaterial3D = buoy_mesh.get_surface_override_material(0)
	if(checkpoint_position == current_checkpoint):
		mat.albedo_color = active_color
	elif(checkpoint_position == current_checkpoint + 1):
		mat.albedo_color = next_color
	else:
		mat.albedo_color = other_color

func _on_checkpoint_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("buoy_entered", self, checkpoint_position)
		%Arrow.hide()


func _on_checkpoint_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player") and Globals.current_checkpoint > checkpoint_position:
		add_child(confetti_particles)
		$Timer.start()
	else:
		%Arrow.show()


func _on_timer_timeout() -> void:
	hide()
