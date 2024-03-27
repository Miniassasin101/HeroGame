# CombatService.gd
#This is the script that handles and reroutes all combat related data,
#and also handles the attack prediciton calculations
extends Node

class_name CombatService

# Signals to communicate combat events
signal target_selected(target_name)
signal attack_executed(attacker_name, target_name, damage)
signal combat_ended(winner)

func _ready():
	LevelBus.connect("attack_button", Callable(self, "_target_selection"))

# Function to select a target based on your criteria (e.g., closest enemy, lowest health)
func _target_selection():
	print("Target Selection Working")
	var range = find_attack_range()
	print(range)
	# Implement target selection logic here
	# Placeholder: return an example target name

func find_attack_range():
	UnitBus.character_roster[LevelBus.selected_unit].update_derived_stats()
	return(UnitBus.character_roster[LevelBus.selected_unit].range)

# Function to calculate attack damage based on attacker and target stats, positions, etc.
func calculate_attack_damage(attacker_name: String, target_name: String) -> int:
	# Implement damage calculation logic here
	# Placeholder: return example damage
	return 10

# Function to execute an attack, applying damage to the target and triggering any side effects
func execute_attack(attacker_name: String, target_name: String):
	var damage = calculate_attack_damage(attacker_name, target_name)
	# Apply damage to the target here (adjust health, check for death, etc.)
	
	# Emit a signal that an attack has been executed
	emit_signal("attack_executed", attacker_name, target_name, damage)

	# Check if the combat has ended (e.g., one side has no more units)
	# If so, emit the combat_ended signal with the name of the winner
	# Placeholder: Emitting combat ended for demonstration
	# emit_signal("combat_ended", "WinnerName")
