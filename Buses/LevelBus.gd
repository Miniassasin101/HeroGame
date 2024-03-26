extends Node

var menu_toggle1 = "default"
var unit_key = "default"
var selected_unit = "default"
signal mousepos(adjint)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func mousesave(adjint):
	print ("Adjint in bus")
	print (adjint)
	emit_signal("mousepos", adjint)
