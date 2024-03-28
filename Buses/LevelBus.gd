extends Node

var menu_toggle1 = "default"
var unit_key = "default"
var selected_unit = "default"
var selected_target = "default"
signal mousepos(adjint)

signal move_button()

signal attack_button()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func mousesave(adjint):
	print ("Adjint in bus")
	print (adjint)
	emit_signal("mousepos", adjint)
	
func _attack_button():
	print ("Attack Button In Bus")
	emit_signal("attack_button")

func _move_button():
	print ("Move Button In Bus")
	emit_signal("move_button")
