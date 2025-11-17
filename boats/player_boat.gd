extends RigidBody3D

@export var float_force = 0.01
@export var water_drag = 0.05
@export var water_angular_drag = 0.05

@export var acceleration = 30.0
@export var decceleration = 30.0

@export var topspeed = 30.133
@export var minspeed = 0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var floats = $FloatContainer.get_children()

var velocity:float = minspeed

var hmap:Dictionary[Vector2i,ViewportTexture]

const water_height = 0.0
var submerged = false

func _ready():
	$CollisionShape3D.shape = $Sphere.mesh.create_convex_shape()

func _physics_process(delta: float) -> void:
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
	#print($FloatContainer/Marker3D6.get_water_height(map,tile))
	
	var point = transform.basis * Vector3.FORWARD
	var dir = Vector3(point.x,0,point.z)
	
	apply_central_force(dir * velocity)

	if Input.is_action_pressed("turn_left"):
		apply_torque(Vector3(0,20,0))
	if Input.is_action_pressed("turn_right"):
		apply_torque(Vector3(0,-20,0))
	if Input.is_action_pressed("forward") and velocity <= topspeed:
		velocity = velocity + (acceleration * delta)
	if Input.is_action_pressed("backward") and velocity >= minspeed:
		velocity = velocity - (decceleration * delta)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
