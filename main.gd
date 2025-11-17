extends Node

@onready var checkpoints : Array

@onready var game_ui : Control = %GameUI 

@onready var player: RigidBody3D = %PlayerBoat

@onready var finish_line: Node3D = null

func _ready() -> void:
	player.hmap = $Ocean.tiles

	LevelManager.set_ui_node(game_ui)

	if player == null:
		push_error("PlayerBoat not found")
	
	if game_ui == null:
		push_error("Missing gameui")
	else:
		game_ui.restart_pressed.connect(_restart)
		game_ui.next_level_pressed.connect(_next_level)
	
	LevelManager.send_finishline.connect(_get_finishline)

	await LevelManager.load_level("res://Levels/level1.tscn")
	LevelManager.current_level_count = 1
	update_checkpoints()

func _process(delta: float) -> void:
	if GameState.current_state == GameState.state.PAUSED:
		return
	
	GameState.time_remaining -= delta
	game_ui.update_time(GameState.time_remaining)

	if GameState.time_remaining <= 0.0:
		LevelManager.fail_level()

func _checkpoint_passed(checkpoint_node: RigidBody3D, index: int):
	if index == GameState.current_checkpoint: # Going around correct checkpoint
		if checkpoint_node.is_correct_side(player.global_position, -player.global_transform.basis.z):
			print("Correct side")
			GameState.increase_checkpoint()
			game_ui.update_checkpoint(GameState.current_checkpoint)
			for b in checkpoints:
				b.updade_checkpoint_color(GameState.current_checkpoint)
		else:
			print("Wrong side")

# Needs to be called everytime level is changed / restarted
func update_checkpoints() -> void: 
	for checkpoint in checkpoints:
		if is_instance_valid(checkpoint):
			if checkpoint.buoy_entered.is_connected(_checkpoint_passed):
				checkpoint.buoy_entered.disconnect(_checkpoint_passed)

	checkpoints = get_tree().get_nodes_in_group("Buoy")

	for checkpoint in checkpoints:
		if is_instance_valid(checkpoint) and is_instance_of(checkpoint, RigidBody3D):
			checkpoint.player_node = player
			var error = checkpoint.buoy_entered.connect(_checkpoint_passed)
			if error != OK:
				push_error("failed to connect")

func reset() -> void:
	print("resetting")
	player.global_position = Vector3(0,0,0)
	player.global_rotation = Vector3.ZERO

	player.linear_velocity = Vector3.ZERO
	player.angular_velocity = Vector3.ZERO

	GameState.current_checkpoint = 1

func _get_finishline(finishline : Node3D):
	finish_line = finishline
	finish_line.finish_line_passed.connect(_on_finished_passed)

func _on_finished_passed():
	if GameState.current_checkpoint == 4: # TODO add level checkpoint count
		LevelManager.completed_level()

func _restart():
	reset()
	await LevelManager.restart_level()
	update_checkpoints()

func _next_level():
	reset()
	await LevelManager.load_level("res://Levels/level2.tscn") # TODO load correct level
	update_checkpoints()
