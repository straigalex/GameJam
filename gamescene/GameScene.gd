extends Node

var checkpoints: Array[RigidBody3D]
@export var player: RigidBody3D

@onready var buoy_container : Node3D = $BuoyContainer
@onready var game_ui : Control = %GameUI 

var current_checkpoint = 1

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
		print(checkpoints)

	if player == null:
		push_error("PlayerBoat not found")

	for i in range(0,checkpoints.size()):
		print("trying to connect ", i)
		if is_instance_valid(checkpoints[i]):
			var child : RigidBody3D = checkpoints[i]
			if child == null:
				push_error("unable to find child")
			var error = child.buoy_entered.connect(_checkpoint_passed)
			if error != OK:
				push_error("failed to connect")
			else:
				print("connected")



func _checkpoint_passed(checkpoint_node: RigidBody3D, index: int):
	if index == current_checkpoint: # Going around correct checkpoint
		if checkpoint_node.is_correct_side(player.global_position):
			print("Correct side")
			current_checkpoint += 1
			game_ui.update_checkpoint(current_checkpoint)
		else:
			print("Wrong side")
