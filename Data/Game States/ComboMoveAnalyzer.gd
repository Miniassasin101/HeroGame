extends Node

var queued_abilities = []

func shiptest(plan):
	print("Shiptest:", plan)
	var reorganized_plan = analyze_and_reorganize_plan(plan)
	print("Reorganized Plan:", reorganized_plan)
	return reorganized_plan
	# Additional logic to execute or further analyze the reorganized plan could go here

	


func analyze_and_reorganize_plan(plan):

	queued_abilities = plan.duplicate()
	print("Analyze and reorganize working", queued_abilities)
	var new_plan = []
	var current_combo = []
	var last_sync_index = -1

	# Iterate through the queued abilities to find and group similar actions
	for i in range(queued_abilities.size()):
		var ability = queued_abilities[i]

		if ability.type == "sync":
			# At each sync, decide if the collected actions form a valid combo
			if current_combo.size() > 0:
				new_plan.append({"type": "combo", "actions": current_combo})
				current_combo = []
			new_plan.append(ability)
			last_sync_index = i
		else:
			# Accumulate actions for potential combo grouping
			var can_be_grouped = _can_be_grouped_with_current_combo(ability, current_combo)
			if can_be_grouped:
				current_combo.append(ability)
			else:
				if current_combo.size() > 0:
					new_plan.append({"type": "combo", "actions": current_combo})
					current_combo = []
				current_combo.append(ability)

	# Add remaining actions to the new plan if any
	if current_combo.size() > 0:
		new_plan.append({"type": "combo", "actions": current_combo})
	print("New Plan: ", new_plan)

	return new_plan

func _can_be_grouped_with_current_combo(ability, current_combo):
	# Implement logic to decide if an ability can be grouped with the current combo
	# This involves checking the ability type, target, and possibly other factors
	# For simplicity, let's assume all movements can be grouped together, and all attacks on the same target can be grouped
	if current_combo.size() == 0:
		return true

	var last_ability = current_combo[current_combo.size() - 1]
	if ability.type != last_ability.type:
		return false

	if ability.type == "move":
		return true  # Simplified assumption: all moves can be grouped
	elif ability.type == "attack":
		return ability.target == last_ability.target  # Group attacks on the same target

	return false


