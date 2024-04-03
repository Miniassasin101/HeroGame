extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_turn():
	print(self.name, " starts its turn.")
	return

func end_turn():
	print("Enemy Turn Ended")
	emit_signal("turn_finished")
	
func _input(event):
	#End Turn Hotkey
	if event.is_action_pressed("End Enemy Turn"):
		LevelBus.turn = "player"
		end_turn()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
