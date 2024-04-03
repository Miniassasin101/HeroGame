extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func blackboard_position(startpos):
	var bt_player = get_child(0)
	print("YOOO")
	bt_player.set_bb_pos_var(startpos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# In a script that needs to find the closest player position
func find_closest_player_position(unit_position) -> Vector3:
	print("Please activate at least")
	print(unit_position)
	var world_state = WorldState # Access the autoloaded WorldState
	var min_distance = INF # Start with infinity as the minimum distance
	var closest_player_name = ""
	var closest_player_position = Vector3()

	# Iterate through player positions to find the closest one
	for player_name in world_state.player_positions.keys():
		var player_position = world_state.player_positions[player_name]
		var distance = unit_position.distance_to(player_position)

		if distance < min_distance:
			min_distance = distance
			closest_player_name = player_name
			closest_player_position = player_position

	# Return both the position and name of the closest player
	print("Closest Player Position: ")
	print(closest_player_position)
	return (closest_player_position)

# Example usage
func _rey():
	var unit_position = Vector3(1, 0, 1) # Example unit position
	var closest_player = find_closest_player_position(unit_position)
	print("Closest player is: ", closest_player["name"], " at position: ", closest_player["position"])
