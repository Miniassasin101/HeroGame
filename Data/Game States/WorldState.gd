#WorldState.gd
#This is a global script that handles all the data that makes up the current state
#of a given level and stores it to be referenced by both Combat controllers and Ai Controllers

extends Node

signal turn_switched(new_turn)
signal position_updated(is_enemy, unit_id, new_position)



var current_turn = "player" # "player" or "enemy"
var player_positions := {}
var enemy_positions := {}
var enemy_roster := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_enemy_to_roster(name: String):
	var path = "res://Data/Resources/Unit Resources/Units/Enemy Units/" + name + ".tres"
	var enemy_resource: UnitStatsResource = load(path)
	if enemy_resource:
		enemy_roster[name] = enemy_resource
		#emit_signal("character_updated", name)
		#emit_signal("roster_updated")
	else:
		push_error("Failed to load character: %s" % path)


func _input(event):
	if event.is_action_pressed("Test T"):
		print("T- Selected Unit Registration for enemy positions")
		print(enemy_roster["Dio"])
		print(enemy_roster["Dio"].name)
		print(UnitBus.character_roster["Sol"].name)

# Method to update the position of a unit
func update_unit_position(unit_name: String, new_position: Vector3, is_enemy: bool = false):
	# Apply the position adjustment
	var adjusted_position = new_position + Vector3(0, -1, 0)
	# Update the appropriate dictionary based on whether the unit is an enemy
	if is_enemy:
		enemy_positions[unit_name] = adjusted_position
		add_enemy_to_roster(unit_name)
	else:
		player_positions[unit_name] = adjusted_position
# Emit a signal indicating a position update
	emit_signal("position_updated", is_enemy, unit_name, adjusted_position)

# Utility methods can be added here for retrieving unit positions or other functionalities as needed

# Method to find an enemy's name based on position
func get_enemy_name_by_position(search_position: Vector3) -> String:
	for name in enemy_positions:
		# Check if the positions match
		if enemy_positions[name] == search_position:
			return name  # Return the name of the enemy
	return ""  # Return an empty string if no enemy is found at that position


func switch_turn():
	current_turn = "enemy" if current_turn == "player" else "player"
	# Notify other parts of the game that the turn has switched
	emit_signal("turn_switched", current_turn)
	
func update_position(is_enemy, unit_id, new_position):
	var positions = enemy_positions if is_enemy else player_positions
	positions[unit_id] = new_position
	# Notify other parts of the game that a unit has moved
	emit_signal("position_updated", is_enemy, unit_id, new_position)
