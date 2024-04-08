@tool
extends BTPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_bb_pos_var(startpos):
	#blackboard = get_blackboard()
	#print(blackboard)
	#print("Blackboard working")
	pass

	#print("TESTTTT")
	#print(blackboard.get_var("current_position"))
	
func set_unit_name_var(unit_name):
	print("Setting Unit Name")
	blackboard.set_var("unit_name", unit_name)
	blackboard.set_var("unit_stat_sheet", WorldState.enemy_roster[unit_name])
	blackboard.bind_var_to_property("unit_ap_var", WorldState.enemy_roster[unit_name], "ap")

	var ap = (blackboard.get_var("unit_stat_sheet").ap)
	blackboard.set_var("unit_ap_var", ap)
func set_enemy_node_name(enemy_name):
	#print("Setting Enemy Name")
	#blackboard.set_var("enemy_node_number", enemy_name)
	pass
	
func _input(event):
	#End Turn Hotkey
	if event.is_action_pressed("Play Tree"):
		print("Pressed")
		
		update(0)
func update_trigger():
	var unit_name = blackboard.get_var("unit_name")
	var startpos = Planning.snapshot_enemy_positions[unit_name]
	var apnum = blackboard.get_var("unit_ap_var")
	print("Statistics: ", unit_name, startpos, apnum)
	while apnum > 0:
		startpos = Planning.snapshot_enemy_positions[unit_name]
		blackboard.set_var("current_position", startpos)
		update(0)
		apnum -= 1

	#update(0)
	#update(0)
	#update(0)


func _process(delta):
	pass
