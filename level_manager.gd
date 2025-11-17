extends Node

var current_level_count : int = 0
var current_level : Node3D = null
var current_level_path : String = ""

var game_ui : Control = null

signal send_finishline(finish_line : Node3D)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func load_level(path: String) -> Node3D:
	# Remove old level
	if current_level and is_instance_valid(current_level):
		print("removing level")

		current_level.queue_free()
		await get_tree().process_frame

	current_level_path = path
	
	# Load new level
	var new_level : Node3D = load(path).instantiate()
	add_child(new_level)
	current_level = new_level

	
	start_level(GameState.default_time)
	var fl = current_level.find_child("FinishLine")
	print(fl)
	emit_signal("send_finishline", fl)
	return new_level

func set_ui_node(node : Control):
	if game_ui == null:
		game_ui = node

	
# Level Management
func start_level(time : float):
	GameState.time_remaining = time
	GameState.current_state = GameState.state.RUNNING
	game_ui.update_gamestate(GameState.current_state)

func restart_level() -> void:
	if current_level:
		await LevelManager.load_level(current_level_path)

func completed_level():
	GameState.current_state = GameState.state.WON
	game_ui.update_gamestate(GameState.current_state)

func fail_level():
	GameState.current_state = GameState.state.LOST
	game_ui.update_gamestate(GameState.current_state)
