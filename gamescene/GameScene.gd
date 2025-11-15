extends Node

@export var checkpoints: Array[RigidBody3D]
@export var player: RigidBody3D

var current_checkpoint = 1

func _ready() -> void:
	if player == null:
		push_error("PlayerBoat not found")
	for i in range(0,checkpoints.size()): # TODO get working
		if checkpoints[i] != null:
			print("connected")
			checkpoints[i].find_child("Checkpoint").buoy_entered.connect(_checkpoint_passed.bind(i))



func _checkpoint_passed(index: int):
	print("passed")
	if index == current_checkpoint: # Going around correct checkpoint
		print("checkpoint passed: ", index)
		current_checkpoint += 1
		if checkpoints[index].is_correct_side(player):
			print("Correct side")
		else:
			print("Wrong side")
