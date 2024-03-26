# HealActionResource.gd
extends ActionResource
class_name HealActionResource

@export var heal_amount: int = 10

func perform_action(target, performer):
	target.heal(heal_amount)
