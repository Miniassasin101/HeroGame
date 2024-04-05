class_name UnitPlan
extends Node

var actions = []

func add_action(action: Action):
	actions.append(action)

func clear_actions():
	actions.clear()

func get_best_action():
	return max(actions, key=lambda a: a.score)
