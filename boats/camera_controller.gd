extends SpringArm3D

@export var mouse_sens = 0.005
@export var min_zoom = 3
@export var max_zoom = 20
@export var zoom_speed = 1
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens
		rotation.y = wrapf(rotation.y, 0.0, TAU)

		rotation.x -= event.relative.y * mouse_sens
		rotation.x = clamp(rotation.x, -PI/2, 0)
	
	if event.is_action_pressed("scroll_up") and spring_length > min_zoom:
		spring_length -= 1
	if event.is_action_pressed("scroll_down") and spring_length < max_zoom:
		spring_length += 1
