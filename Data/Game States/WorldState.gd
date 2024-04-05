#WorldState.gd
#This is a global script that handles all the data that makes up the current state
#of a given level and stores it to be referenced by both Combat controllers and Ai Controllers

extends Node


signal turn_switched(new_turn)
signal position_updated(is_enemy, unit_id, new_position)
signal snapshot(player_positions, enemy_positions, enemy_roster)
@onready var plan_service = $Services/PlanService



var current_turn = "player" # "player" or "enemy"
var player_positions := {}
var enemy_positions := {}
var enemy_roster := {}
var blank_dictionary := {}
var enemy_count = {}  # A dictionary to keep track of the number of each type of enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func contestie():
	print("CONTESTIEEEE")
func add_enemy_to_roster(name: String):
	print("Add Ennemy To Roster %s" %name)
	# Extract base name without numeric suffix
	var base_name = get_base_type(name) # Custom method to implement, see below
	var path = "res://Data/Resources/Unit Resources/Units/Enemy Units/" + base_name + ".tres"
	var enemy_resource: StatBlockResource = load(path)
	print("Enemy Resource Check")
	print(enemy_resource)
	if enemy_resource:
		# Duplicate the resource to create a unique copy for this enemy
		var unique_enemy_resource: StatBlockResource = enemy_resource.duplicate()
		enemy_roster[name] = unique_enemy_resource
		#emit_signal("character_updated", name)
		#emit_signal("roster_updated")
	else:
		push_error("Failed to load character: %s" % path)
		
# Custom method to extract base type name from a string like "Wolf 1"
func get_base_type(name: String) -> String:
	var parts = name.split(" ")
	if parts.size() > 1:
		var last_part = parts[parts.size() - 1]
		if last_part.is_valid_int():  # Check if the last part is a valid integer
			parts.remove_at(parts.size() - 1)  # Remove the last element if it's a number
			return " ".join(parts)  # Join the list back into a string without the number
	return name





func _input(event):
	if event.is_action_pressed("Test T"):
		print("T- Selected Unit Registration for enemy positions")
		print(enemy_positions["Wolf"])
		#print(enemy_roster["Dio"])
		#print(enemy_roster["Dio"].name)
		#print(UnitBus.character_roster["Sol"].name)

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

# Method to find a player's name based on position
func get_player_name_by_position(search_position: Vector3) -> String:
	for name in player_positions:
		# Check if the positions match
		if player_positions[name] == search_position:
			return name  # Return the name of the player unit
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

# Function to send the current state snapshot to PlanState when it's the enemy's turn.
func send_state_to_plan_state():
	print("Sending Plan")
	var planning = Planning

	print(plan_service)
	# Assuming PlanState is a singleton or adjust the path as needed
	planning._initialize_with_snapshot(player_positions, enemy_positions, enemy_roster)
		
