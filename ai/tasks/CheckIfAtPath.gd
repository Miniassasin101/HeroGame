@tool

extends BTCheckVar

func _tick(delta: float):
	var vec = blackboard.get_var("path_to_enemy")
	var blank_array = PackedVector3Array([Vector3(0, 0, 0)])
	if vec == blank_array:
		print("No Path damn")
		return FAILURE
	print("Path To Enemy")
	print(vec)
	var path_length = get_path_length(vec)
	blackboard.set_var("path_length_var", path_length)
	if path_length > 1:
		return SUCCESS
	else:
		print("Already next to enemy")
		return FAILURE
	
func get_path_length(path: PackedVector3Array) -> int:
	return path.size()
	
