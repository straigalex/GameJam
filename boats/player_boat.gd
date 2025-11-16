extends RigidBody3D

@export var float_force = 0.03
@export var water_drag = 0.05
@export var water_angular_drag = 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var floats = $FloatContainer.get_children()

var hmap:Dictionary[Vector2i,ViewportTexture]

const water_height = 0.0
var submerged = false

func _physics_process(_delta: float) -> void:
	submerged = false
	
	var pos = Vector2(global_position.x,global_position.z)
	var dist:float = pos.distance_to(GameState.TILES.keys()[0])
	
	var tile = Vector2i(30,30)
	
	for key in GameState.TILES.keys():
		var newdist = pos.distance_to(key)
		if(newdist <= dist):
			dist = newdist
			tile = key
	
	var map = GameState.TILES.get(tile).get_image()
	
	for f in floats:
		var wheight = f.get_water_height(map,tile)
		var depth = wheight - f.global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, f.global_position - global_position)
	
	var movbas = Basis(transform.basis.x,Vector3(0,0,0),transform.basis.z)
	
	apply_central_force(movbas * Vector3.FORWARD * 20)

	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0,20,0))
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0,-20,0))

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
