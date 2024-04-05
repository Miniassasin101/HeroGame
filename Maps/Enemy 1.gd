extends Node

@onready var Name = "Default"
var btplayer3 = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_node_name(unit_name):
	Name = unit_name
	print("SelfName:")
	print(Name)
	var btplayer1 = get_child(1)
	var btplayer2 = btplayer1.get_child(0)
	btplayer3 = btplayer2.get_child(0)
	btplayer3.set_unit_name_var(unit_name)
	btplayer3.set_enemy_node_name(self.name)
	
func begin():
	btplayer3.update_trigger()
