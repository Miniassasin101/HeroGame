# Combatants.gd
extends Node

var current_group_index = 0
var groups = []

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
	
	# Move to the next group
	current_group_index += 1
	if current_group_index >= groups.size():
		# If we've gone through all groups, start over
		current_group_index = 0
		print("All groups have taken a turn. Starting over.")
	# Start the next group's turn
	groups[current_group_index].start_turn()
