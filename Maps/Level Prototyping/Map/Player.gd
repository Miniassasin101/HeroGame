extends Node3D

@onready var grid_map = $"../GridMap"

var astar_grid: AStar3D
# Called when the node enters the scene tree for the first time.
func _ready():
	astar_grid = AStar3D.new()
	astar_grid.region = grid_map.get_used_rect()
	astar_grid.cell_size = Vector3(0.7, 0.7, 0.7)
	astar_grid.update()
	
	

func _input(event):
	event.is_action_pressed("move") == false:
		return
	
	var id_path = astar_
