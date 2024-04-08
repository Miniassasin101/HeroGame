# ClosestPlayerAction.gd
@tool
extends BTCallMethod

# Reference to the Pathfinding node


# Reference to WorldState for accessing player positions
var world_state = WorldState

func _tick(delta):
	print("Success Code Yah")
	set_method("find_closest_player_position")
	var unit_name = blackboard.get_var("unit_name")
	var animation_controller_path = ("Combatants/Opponent Combatant Group/%s/Controllers/Animation Controller" % unit_name)
	var animation_controller = get_node("../../../../" + animation_controller_path)
	return SUCCESS
Combatants/Opponent Combatant Group/Enemy 1/Controllers/AI Controller
