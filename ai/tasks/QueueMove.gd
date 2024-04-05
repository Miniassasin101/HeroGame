@tool
extends BTAction

@export var Queue_Type: String
@export var target_position: Vector3
@export var unit_name: String

func _tick(delta: float):
	var enemy_node_number = blackboard.get_var("unit_name")
	var target_position = blackboard.get_var("target_position_vec3")
	Planning.queue_move_ability(target_position, enemy_node_number)
	print("MoveQueue Kal")
