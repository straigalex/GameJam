extends Area3D

enum buoy_directions {
	PORT_SIDE,
	STARBOARD_SIDE
}

@export var checkpoint_position = -1
@export var required_direction = buoy_directions.PORT_SIDE
@onready var buoy_facing: Marker3D = $CheckpointFacing

signal buoy_entered()

func _ready() -> void:
	$Label3D.text = "Checkpoint " + str(checkpoint_position) 

func _process(delta: float) -> void:
	$Label3D.look_at() # TODO make label face player

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
		

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("emiting signal")
		emit_signal("buoy_entered", self)
