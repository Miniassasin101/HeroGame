# PlanService.gd

extends Node

func _ready():
	WorldState.connect("snapshot", Callable(self, "initialize_with_snapshot"))
	
func initialize_with_snapshot():
	print("123456789")
