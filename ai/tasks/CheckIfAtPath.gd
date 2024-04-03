@tool

extends BTCheckVar

func _tick(delta: float):
	var vec = blackboard.get_var("path_to_enemy")
	var path_length = get_path_length(vec)
	blackboard.set_var("path_length_var", path_length)
	return SUCCESS
func get_path_length(path: PackedVector3Array) -> int:
	return path.size()
