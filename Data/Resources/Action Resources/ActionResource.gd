# ActionResource.gd
#Class for creating actions that can be modularly attatched to a unit.
extends Resource
class_name ActionResource

@export var action_name: String = "Unnamed Action"
@export var ap_cost: int = 1
@export var range: int = 1
# Additional properties as needed, e.g., effects, targeting logic, etc.

func execute_action(caster: StatBlockResource, target: Vector3):
	# Implementation of the action's effects
	pass
