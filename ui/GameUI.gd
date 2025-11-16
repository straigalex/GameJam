extends Control

func _ready() -> void:
	%CheckpointLabel.text = "Current Goal: 1"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	%PauseMenu.hide()
	%GameStateLabel.text = "PAUSED"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if GameState.current_state == GameState.state.PAUSED:
			resume_game()
		elif GameState.current_state == GameState.state.RUNNING:
			pause_game()

func update_checkpoint(current_checkpoint: int) -> void:
	%CheckpointLabel.text = "Current Goal: " + str(current_checkpoint)

func update_time(time_remaining: float):
	%TimeRemainingLabel.text = "Time Remaining: " + format_time(time_remaining)

func update_gamestate(state : GameState.state):
	if state == GameState.state.WON:
		pause_game()
		%GameStateLabel.text = "Level Complete"
		%GameStateLabel.show()
	elif state == GameState.state.LOST:
		pause_game()
		%GameStateLabel.text = "Level Failed"
		%GameStateLabel.show()


func format_time(t: float) -> String:
	if t < 0: t = 0
	var m = int(t) / 60
	var s = int(t) % 60
	var ms = int((t - int(t)) * 1000)
	return "%02d:%02d.%03d" % [m, s, ms]

func pause_game() -> void:
	GameState.current_state = GameState.state.PAUSED
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%PauseMenu.show()
	get_tree().paused = true

func resume_game() -> void:
	GameState.current_state = GameState.state.RUNNING
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	%PauseMenu.hide()
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
