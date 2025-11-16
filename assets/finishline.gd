extends Node3D

signal finish_line_passed()

func _on_finish_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("finish_line_passed")
