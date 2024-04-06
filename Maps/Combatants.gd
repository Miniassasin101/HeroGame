# Combatants.gd
extends Node

var current_group_index = 0
var groups = []
@onready var oppgroup = get_child(1)
func _ready():
	# Initialize the groups array with child nodes, assuming each child is a group
	groups = get_children()
	
	for group in groups:
		group.connect("turn_finished", Callable(self, "_on_group_turn_finished"))

	# Start the first group's turn
	if groups.size() > 0:
		groups[current_group_index].start_turn()

func _on_group_turn_finished():
	print(groups[current_group_index].name, " finished its turn.")
		# Reset AP for all characters in the current group
	if current_group_index == 0:
		LevelBus.turn = "enemy"
	else :
		LevelBus.turn = "player"
	WorldState.send_state_to_plan_state()

	# Move to the next group
	current_group_index += 1
	if current_group_index >= groups.size():
		# If we've gone through all groups, start over
		current_group_index = 0
		print("All groups have taken a turn. Starting over.")
		for character_key in UnitBus.character_roster.keys():
			var character = UnitBus.character_roster[character_key]
			# Assuming reset_ap() is a method within each character's stats resource or similar object
			character.reset_ap()
			print(character.name + "'s AP has been reset.")
			WorldState.send_state_to_plan_state()
		#for enemy_key in WorldState.enemy_roster.keys():
			#var character =
	# Start the next group's turn
	var current_test_enemy = $"Opponent Combatant Group/Enemy 1/Controllers/AI Controller/BTPlayer"

	#if current_group_index == 1:
	#	current_test_enemy.update()
	if LevelBus.turn == "enemy":
		oppgroup.turn_start()
	
	LevelBus.updater()
	groups[current_group_index].start_turn()

func target_query(pos):
	var target_name = WorldState.get_player_name_by_position(pos)
	return target_name
