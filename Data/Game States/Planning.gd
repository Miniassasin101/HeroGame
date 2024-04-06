# Planning.gd
#this is an autoloaded script that serves as a temporary worldstate for the ai to plan on
extends Node

var world_state: WorldState
var queued_abilities = []
var sync_markers = []

var snapshot_player_positions := {}
var snapshot_enemy_positions := {}
var snapshot_enemy_roster := {}

# Keep track of the last unit that had an ability queued
var last_unit_queued: String = ""

func _input(event):
	if event.is_action_pressed("Test T"):
		print("Test T Planning")
		print("Queued abilities: ", queued_abilities)

		

func _ready():
	pass

func contest():
	print("CONTEST")

func _initialize_with_snapshot(player_positions, enemy_positions, enemy_roster):
	print("Initialize With Snapshot")
	snapshot_player_positions = player_positions.duplicate()
	snapshot_enemy_positions = enemy_positions.duplicate()
	snapshot_enemy_roster = enemy_roster.duplicate()
	queued_abilities = []
	print(snapshot_enemy_positions)
	print("Snapshot initialized with current WorldState.")

func queue_move_ability(target_position: Vector3, unit_name: String, unit_path: PackedVector3Array):
	print("Move Ability Queueing")
	# Create a new ability dict representing the move action
	var ability = {
		"type": "move",
		"unit": unit_name,
		"target_position": target_position,
		"unit_path": unit_path,
	}
	# Queue the move ability
	#queued_abilities.append(ability)
	queue_ability(ability)
	# Update the snapshot_enemy_positions as if there was a unit at the target position
	snapshot_enemy_positions[unit_name] = target_position
	print("Position Updated: ")
	print(unit_name)
	print(snapshot_enemy_positions)

func queue_ability(ability):
	if ability.has("unit") and ability["unit"] != last_unit_queued:
		# Add a sync marker if this is a new unit
		add_sync_marker()
		# Simulate ability effect in PlanState
	# Queue the ability and update the last queued unit
	queued_abilities.append(ability)
	last_unit_queued = ability.get("unit", "")

func add_sync_marker():
	# Only add a sync marker if there's at least one ability queued
	# and the last item isn't already a sync marker to prevent consecutive markers.
	if queued_abilities.size() > 0 and (queued_abilities[-1] as Dictionary).get("type") != "sync":
		queued_abilities.append({"type": "sync"})
		print("Sync Marker Added")

func combo_ship():
	ComboMoveAnalyzer.shiptest(queued_abilities)

func simulate_ability(ability):
	# Example: If ability is 'move', update unit's position in PlanState
	if ability.type == "move":
		simulate_move(ability)
	elif ability.type == "attack":
		simulate_attack(ability)
	# Add more simulations as needed

func simulate_move(ability):
	pass

func simulate_attack(ability):
	pass



func execute_plan():
	pass
	# Logic to execute queued abilities in real game world, up to next sync marker
