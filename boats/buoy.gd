extends RigidBody3D

# Buoy
@export var float_force = 1.0
@export var water_drag = 0.05
@export var water_angular_drag = 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

const water_height = 0.0
var submerged = false

# Checkpoint
enum buoy_directions {
	PORT_SIDE,
	STARBOARD_SIDE
}

signal buoy_entered(buoy_node: RigidBody3D, index: int)

@export var checkpoint_position = -1
@export var required_direction = buoy_directions.PORT_SIDE

@onready var buoy_facing: Marker3D = %Marker3D
@onready var checkpoint = %CheckpointArea
@onready var label = $Label3D

func _ready() -> void:
	label.text = "Checkpoint " + str(checkpoint_position) 

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


func is_correct_side(boat_position: Vector3) -> bool:
	var side_vector = (buoy_facing.global_position - global_position).normalized()
	var player_vector = (boat_position - global_position).normalized()

	var correct_side_vector = side_vector.cross(Vector3.UP).normalized()

	var dot = player_vector.dot(correct_side_vector)

	if required_direction == buoy_directions.PORT_SIDE:
		return dot < 0
	elif required_direction == buoy_directions.STARBOARD_SIDE:
		return dot > 0
	

	return false

func _on_checkpoint_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("buoy_entered", self, checkpoint_position)
