@tool
extends BTAction


func _tick(delta: float):
	var ap = (blackboard.get_var("unit_stat_sheet").ap)
	blackboard.set_var("unit_ap_var", ap)
	print(blackboard.get_var("unit_ap_var"))
	print("Stats Added")
	return SUCCESS
