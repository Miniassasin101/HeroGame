extends Node


var stat_block: StatBlockResource
#var current_plan: UnitPlan = UnitPlan.new()
var unit_name = true
@onready var plan_service = $"../../../../../Services/PlanService"

func _ready():
	pass  # Initialize AI, etc.
func blackboard_position(adjpos):
	var ai_controller = get_child(0)
	ai_controller.set_bb_pos_var(adjpos)
func set_unit_name_var(name):
	unit_name = name
	print(unit_name)
#connecting to PlanService
#func get_tiles(name):

#func get_reachable_tiles():
	# Use Pathfinding script to get reachable tiles based on movement AP
	#pass

#func evaluate_tile(tile: Vector3) -> float:
	# Score tile based on utility (e.g., potential attacks, strategic value)
	#return score
