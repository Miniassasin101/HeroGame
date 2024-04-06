@tool
extends BTAction

@export var Queue_Type: String
@export var target_position: Vector3
@export var unit_name: String

func _tick(delta: float):
	var unit_name = blackboard.get_var("unit_name")
	var target_position = blackboard.get_var("target_position_vec3")
	var unit_path = blackboard.get_var("path_to_enemy")
	Planning.queue_move_ability(target_position, unit_name, unit_path)
	print("MoveQueue Kal")
