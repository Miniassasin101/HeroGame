extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_turn():
	print(self.name, " starts its turn.")
	return

func turn_start():
	for child in get_children():
		# Check if the child has a method named 'begin'
		if child.has_method("begin"):
			# Call the 'begin' method on the child
			child.call("begin")
			print("Begin Called")
			#await get_tree().create_timer(5.0).timeout
	Planning.combo_ship()


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
func ap_cost_manager():
	pass
