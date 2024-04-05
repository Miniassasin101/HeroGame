# PlanService.gd
class_name ActionPlan
extends Node

var unit_id: String
var action: ActionResource
var target: Vector3
var priority: int

func _init(_unit_id: String, _action: ActionResource, _target: Vector3, _priority: int = 0):
	unit_id = _unit_id
	action = _action
	target = _target
	priority = _priority
