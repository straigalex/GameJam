extends Node3D

func _physics_process(delta: float) -> void:
    rotation = lerp(rotation, -velocity,delta)