@tool
extends BTCallMethod

# Initialization of properties based on the documentation and requirements
func _init():
	set_method = "queue_move_for_unit"
	node = BBNode.new()
	# Assuming PlanState is a globally accessible node or set correctly somewhere else
	node.set_node_param("/root/PlanState")  # Adjust the path as needed

	# Args will be dynamically set based on the Blackboard data during the tick

func _tick(delta: float) -> int:
	# Retrieve necessary data from Blackboard
	var enemy_node_number = blackboard.get_var("enemy_node_number")
	var path_to_enemy: PackedVector3Array = blackboard.get_var("path_to_enemy")

	# Check if the path is not empty
	if path_to_enemy.size() > 0:
		# We only need the last position in the path
		var target_position = path_to_enemy[path_to_enemy.size() - 1]
		
		# Prepare the arguments for the method call
		set_args(enemy_node_number, target_position)

		# Call the parent class method to execute the call
		#var status = .execute(delta)

		# Return the execution status
		return status

	# Return FAILURE if the path is empty or data is missing
	return FAILURE
