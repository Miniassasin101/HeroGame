# AttackActionResource.gd

class_name AttackActionResource extends ActionResource


@export var damage: int = 10

func perform_action(target, performer):
	target.apply_damage(damage)
