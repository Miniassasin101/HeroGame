extends Node3D

var grid_step := 0.75
var grid_y := 0.5
var points := {}
var astar = AStar3D.new()
@onready var pathables = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	var pathables = get_tree().get_nodes_in_group("pathable")
	_add_points(pathables)
	_connect_points() 

func _add_points():
	for pathable in pathables:
		var mesh = pathable.get_node("LevelProto")
		var aabb: AABB = mesh.get_transformed_aabb()
		
		var start_point = aabb.position
		
		var x_steps = aabb.size.x / grid_step
		var z_steps = aabb.size.z / grid_step
		
		for x in x_steps:
			for z in z_steps:
				var next_point = start_point + Vector3(x * grid_step, 0, z * grid_step)
				_add_point(next_point)


func _add_point(point: Vector3):
	point.y = grid_y
	
	var id = astar.get_available_point_id()
	astar.add_point(id, point)
	points[local_to_astar(point)] = id
	
	
func _connect_points():
	for point in points:
		pass
		
		
func find_path(from: Vector3, to: Vector3) -> Array:
	return []
	
func local_to_astar(local: Vector3) -> String:
	var x = snappedi(local.x, grid_step)
	var y = snappedi(local.y, grid_step)
	var z = snappedi(local.z, grid_step)
	return "%d, %d, %d" % [x, y, z]

