extends Node

signal move_completed
#@onready var animation_controller = $"../../../../Combatants/Opponent Combatant Group/Enemy 1/Controllers/Animation Controller"


# Called when the node enters the scene tree for the first time.
#INFO: comser = Combat Service

func _ready():
	connect("moveparse", Callable(self, "moveparse"))



func moveparse(unit_path, unit_name):
	print("Moveparser working: ", unit_path, unit_name)
	var animation_controller_path = ("Combatants/Opponent Combatant Group/%s/Controllers/Animation Controller" % unit_name)
	var animation_controller = get_node("../../../../" + animation_controller_path)
	#await animation_controller.move_ai_unit(unit_path, unit_name)
	await animation_controller.move_ai_unit_starter(unit_path, unit_name)
	return true
	#comser.move_ai_unit_along_path(unit_path, unit_name)
	#Planning.emit_signal("move_completed")
	#Planning.signal_emitter()
