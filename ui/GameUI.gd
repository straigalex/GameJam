extends Control

func _ready() -> void:
    $CheckpointLabel.text = "Current Goal: 1"
    self.mouse_filter = Control.MOUSE_FILTER_IGNORE

func update_checkpoint(current_checkpoint: int) -> void:
    $CheckpointLabel.text = "Current Goal: " + str(current_checkpoint)