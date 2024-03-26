extends Node

signal move_button()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("taco change")
	pass


func _on_move_button_pressed():
	LevelBus.menu_toggle1 = "move"
	print("in move mode and selected unit is: " + LevelBus.selected_unit)
	emit_signal("move_button")
