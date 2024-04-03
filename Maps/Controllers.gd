extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func write_position_to_blackboard(startpos):
	var ai_controller = get_child(0)
	print("Controller Check")
	print(startpos)
	var adjpos = startpos + Vector3(0, -1, 0)
	ai_controller.blackboard_position(adjpos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
