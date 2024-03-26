# ActionResource.gd
extends Resource
class_name ActionResource

@export var name: String = "Unnamed Action"
@export var description: String = "No Description"
@export var action_cost: int = 0

func perform_action(target, performer):
	# Placeholder for action logic
	pass
