extends Node

enum state{
	RUNNING,
	PAUSED,
	WON,
	LOST
}

var current_checkpoint: int = 1
var time_remaining : float = 0.0
var current_state : state = state.RUNNING
var current_level : int = 1
var current_level_node : Node3D = null

var game_ui_node : Control = null
var game_scene_node: Node3D = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_ui_node(node : Control):
	if game_ui_node == null:
		game_ui_node = node

func increase_checkpoint() -> void:
	current_checkpoint += 1

func set_time(time : float):
	time_remaining = time

func add_time(time: float):
	time_remaining += time

# Level Management
func start_level(time : float):
	time_remaining = time
	current_state = state.RUNNING

func completed_level():
	current_state = state.WON
	game_ui_node.update_gamestate(current_state)

func fail_level():
	current_state = state.LOST
	game_ui_node.update_gamestate(current_state)

func restart_level():
	pass

func next_level():
	current_level += 1

var TILES:Dictionary[Vector2i,ViewportTexture]
