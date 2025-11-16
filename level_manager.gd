extends Node

var current_level : Node3D = null

func load_level(path: String) -> Node3D:
    # Switch level node
    if current_level and is_instance_valid(current_level):
        current_level.queue_free()
        await get_tree().process_frame
    

    var new_level : Node3D = load(path).instantiate()
    add_child(new_level)
    current_level = new_level

    return new_level