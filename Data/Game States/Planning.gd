# PlanState.gd
#this is an autoloaded script that serves as a temporary worldstate for the ai to plan on
extends Node

var world_state: WorldState
var queued_abilities = []
var sync_markers = []

var snapshot_player_positions := {}
var snapshot_enemy_positions := {}
var snapshot_enemy_roster := {}




func _ready():
	pass

func contest():
	print("CONTEST")

func _initialize_with_snapshot(player_positions, enemy_positions, enemy_roster):
	print("Initialize With Snapshot")
	snapshot_player_positions = player_positions.duplicate()
	snapshot_enemy_positions = enemy_positions.duplicate()
	snapshot_enemy_roster = enemy_roster.duplicate()
	print(snapshot_enemy_positions)
	print("Snapshot initialized with current WorldState.")

func queue_move_ability(target_position: Vector3, unit_name: String):
	print("Move Ability Queueing")
	# Create a new ability dict representing the move action
	var ability = {
		"type": "move",
		"unit": unit_name,
		"target_position": target_position
	}
	# Queue the move ability
	queued_abilities.append(ability)
	# Update the snapshot_enemy_positions as if there was a unit at the target position
	snapshot_enemy_positions[unit_name] = target_position
	print("Position Updated: ")
	print(unit_name)
	print(snapshot_enemy_positions)

func queue_ability(ability):
	# Simulate ability effect in PlanState
	simulate_ability(ability)
	queued_abilities.append(ability)

func simulate_ability(ability):
	# Example: If ability is 'move', update unit's position in PlanState
	if ability.type == "move":
		simulate_move(ability)
	elif ability.type == "attack":
		simulate_attack(ability)
	# Add more simulations as needed

func simulate_move(ability):
	var unit = ability.unit
	var target_position = ability.target_position
	# Update unit's position in PlanState
	# Ensure to clone or deep-copy objects if needed to not affect WorldState

func simulate_attack(ability):
	var unit = ability.unit
	var target_unit = ability.target
	var damage = ability.damage
	# Simulate attack and update target unit's health in PlanState

func add_sync_marker():
	sync_markers.append(len(queued_abilities))

func execute_plan():
	pass
	# Logic to execute queued abilities in real game world, up to next sync marker
