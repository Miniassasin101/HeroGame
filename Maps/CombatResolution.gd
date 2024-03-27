# CombatService.gd
#This is the script that handles and reroutes all combat related data,
#and also handles the attack prediciton calculations
extends Node

class_name CombatService

# Signals to communicate combat events
signal target_selected(target_name)
signal attack_executed(attacker_name, target_name, damage)
signal combat_ended(winner)

func _init():
	pass # Initialization code here, if needed

# Function to select a target based on your criteria (e.g., closest enemy, lowest health)
func select_target(attacker_position: Vector3, is_enemy: bool) -> String:
	# Implement target selection logic here
	# Placeholder: return an example target name
	return "TargetName"

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
