# PlanState.gd
extends Node


var world_state: WorldState
var queued_abilities = []
var sync_markers = []

func _init(_world_state: WorldState):
	world_state = _world_state

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
