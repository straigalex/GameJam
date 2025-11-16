extends Node

var checkpoints: Array[RigidBody3D]
@export var player: RigidBody3D

@onready var buoy_container : Node3D = $BuoyContainer
@onready var game_ui : Control = %GameUI 

func _ready() -> void:
	checkpoints.clear()
	if buoy_container == null:
		push_error("unable to find buoy container")
	else:
		for child in buoy_container.get_children():
			if child is RigidBody3D:
				checkpoints.push_back(child)
			else:
				push_error("BuoyContainer contains a invalid child")

	if player == null:
		push_error("PlayerBoat not found")

	for i in range(0,checkpoints.size()):
		if is_instance_valid(checkpoints[i]):
			var child : RigidBody3D = checkpoints[i]
			child.player_node = player
			if child == null:
				push_error("unable to find child")
			var error = child.buoy_entered.connect(_checkpoint_passed)
			if error != OK:
				push_error("failed to connect")



func _checkpoint_passed(checkpoint_node: RigidBody3D, index: int):
	if index == Globals.current_checkpoint: # Going around correct checkpoint
		if checkpoint_node.is_correct_side(player.global_position, -player.global_transform.basis.z):
			print("Correct side")
			Globals.current_checkpoint += 1
			game_ui.update_checkpoint(Globals.current_checkpoint)
			for b in checkpoints:
				b.updade_checkpoint_color(Globals.current_checkpoint)
		else:
			print("Wrong side")
