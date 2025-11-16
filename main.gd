extends Node

@onready var checkpoints : Array = get_tree().get_nodes_in_group("Buoy")

@onready var game_ui : Control = %GameUI 

@export var player: RigidBody3D

func _ready() -> void:
	LevelManager.load_level("res://Levels/level1.tscn")

	GameState.set_ui_node(game_ui)

	if player == null:
		push_error("PlayerBoat not found")

	# for i in range(0,checkpoints.size()):
	# 	if is_instance_valid(checkpoints[i]):
	# 		var child : RigidBody3D = checkpoints[i]
	# 		child.player_node = player
	# 		if child == null:
	# 			push_error("unable to find child")
	# 		var error = child.buoy_entered.connect(_checkpoint_passed)
	# 		if error != OK:
	# 			push_error("failed to connect")
	print(checkpoints.size())
	for checkpoint in checkpoints:
		print(checkpoint)
		if is_instance_valid(checkpoint) and is_instance_of(checkpoint, RigidBody3D):
			checkpoint.player_node = player
			print("connected")
			var error = checkpoint.buoy_entered.connect(_checkpoint_passed)
			if error != OK:
				push_error("failed to connect")

	GameState.start_level(10.0)

func _process(delta: float) -> void:
	if GameState.current_state == GameState.state.PAUSED:
		return
	
	GameState.time_remaining -= delta
	game_ui.update_time(GameState.time_remaining)

	if GameState.time_remaining <= 0.0:
		GameState.fail_level()

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
	checkpoints.clear()
	checkpoints = get_tree().get_nodes_in_group("Buoy")
