extends Node

enum state{
	RUNNING,
	PAUSED,
	WON,
	LOST
}

var current_checkpoint: int = 1
var time_remaining : float = 0.0
var default_time : float = 60.0
var current_state : state = state.RUNNING

var TILES:Dictionary[Vector2i,ViewportTexture]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	process_mode = Node.PROCESS_MODE_ALWAYS

func increase_checkpoint() -> void:
	current_checkpoint += 1

func set_time(time : float):
	time_remaining = time

func add_time(time: float):
	time_remaining += time
