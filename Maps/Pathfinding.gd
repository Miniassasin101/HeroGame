#Pathfinding.gd
#this script handles AStar3d pathfinding and the actual logic of moving the sprite
extends Node

# Variables to hold references to the GridMap and AStar3D nodes
@onready var grid_map = $"../../../Environment/Tilemaps/GridMap"

@onready var sprite_3d = $Sprite3D
@onready var camera_3d = $"../../../Environment/Cameras/Camera3D"
@onready var enemy = true



var astar = AStar3D.new()

func _ready():
	#connect points
	LevelBus.connect("mousepos", Callable(self, "_movement_var_collecter"))
	# Initialize AStar with GridMap cells
	initialize_astar_from_gridmap()
	#Connect GridMap cells to create paths
	connect_astar_points()
	var spritepos = Vector3(0, 0, 0)
	#print("ReadyPos:")
	#print(spritepos)
	var adjspritepos = spritepos + Vector3(0, -1, 0)
	#print(adjspritepos)
	#Testing Function
	find_and_print_path(Vector3(0, 3, 1), Vector3(5, 0, 2))
	
func _movement_var_collecter(mpos):
	var movechar = get_node("../../../Combatants/Player Combatant Group/Unit 1/Controllers/Animation Controller/" + LevelBus.selected_unit)
	print("MoveVarCol:")
	print(mpos)
	print("Enemy Check: ")
	print(enemy)
	var spritepos = movechar.get_position()
	var adjspritepos = spritepos + Vector3(0, -1, 0)
	print("ASP: ")
	print(adjspritepos)
	if mpos == null:
		print ("Null Mouse Position")
		
		emit_signal("move_button")
	else:
		find_path_and_move_sprite(adjspritepos, mpos)

func find_path_and_move_sprite(start_pos: Vector3, end_pos: Vector3):
	#print(start_pos)
	#print(end_pos)
	LevelBus.menu_toggle1 = "wait"
	var start_id = vector3i_to_id(grid_map.local_to_map(start_pos))
	var end_id = vector3i_to_id(grid_map.local_to_map(end_pos))
	var path = astar.get_point_path(start_id, end_id)
	print("Path Pt 2: ")
	print(path)
	if path.size() > 0:
		print("Path found. Moving " + LevelBus.selected_unit + ".")
		move_sprite_along_path(path)
	else:
		print("No path found between the specified points.")

func move_sprite_along_path(path: PackedVector3Array):
	var tween = get_tree().create_tween()
	var movechar = get_node("../../../Combatants/Player Combatant Group/Unit 1/Controllers/Animation Controller/" + LevelBus.selected_unit)
	var duration_per_segment = 0.3 # Adjust based on how fast you want the sprite to move
	for i in range(path.size() - 1):
		var to_position = path[i + 1]
		print("To Position:")
		print(to_position)
		var actualmov = to_position + Vector3(.25, 1, .25)
		print("Actual Move:")
		print(actualmov)
		var updatepos = to_position + Vector3(0, 1, 0)
		WorldState.update_unit_position(LevelBus.selected_unit, updatepos)
		tween.tween_property(movechar, "position", Vector3(actualmov), duration_per_segment).set_trans(0).set_ease(2)
		if i < path.size() - 2: # Chain all but the last segment
			tween = tween.chain()
	tween.play()
	


	


func _on_tween_completed(tween, key):
	pass
	#print("Sprite movement completed")

func initialize_astar_from_gridmap():
	var cube_mesh = create_green_cube_mesh()
	for cell in grid_map.get_used_cells():
		# Convert GridMap cell position to world position
		var world_position = grid_map.map_to_local(cell)
		# Use a simple ID conversion method (ensure uniqueness based on your grid size)
		var point_id = vector3i_to_id(cell)
		# Add the point to AStar3D
		astar.add_point(point_id, world_position)
		var cube_instance = MeshInstance3D.new()
		cube_instance.mesh = cube_mesh
		cube_instance.transform.origin = world_position + Vector3(0, 0, 0) # Place one unit above
		add_child(cube_instance)

func vector3i_to_id(vec: Vector3i) -> int:
	# Simple conversion from Vector3i to a unique integer ID
	return vec.x + 1000 * vec.y + 1000000 * vec.z

func connect_astar_points():
	# Example function to connect AStar points based on adjacency
	# This part depends on your specific game logic
	for cell in grid_map.get_used_cells():
		var point_id = vector3i_to_id(cell)
		# Example: Connect this cell with its immediate neighbors
		for offset in [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(1, 1, 0), Vector3i(-1, 1, 0), Vector3i(0, 0, 1), Vector3i(0, 0, -1), Vector3i(0, 1, 1), Vector3i(0, 1, -1)]:
			var neighbor = cell + offset
			if grid_map.get_cell_item(neighbor) != GridMap.INVALID_CELL_ITEM:
				var neighbor_id = vector3i_to_id(neighbor)
				# Connect the points if both current and neighbor cells are filled
				astar.connect_points(point_id, neighbor_id, true) # 'true' for bidirectional

func create_green_cube_mesh() -> Mesh:
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(0.25, 0.25, 0.25) # Cube size, adjust as needed
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 1, 0) # Green color
	cube_mesh.material = material
	return cube_mesh

func create_red_cube_mesh() -> Mesh:
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(0.5, 0.5, 0.5) # Cube size, adjust as needed
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0) # Green color
	cube_mesh.material = material
	return cube_mesh


# Function to find and #print a path between two points
func find_and_print_path(start_pos: Vector3, end_pos: Vector3):
	var start_id = vector3i_to_id(grid_map.local_to_map(start_pos))
	var end_id = vector3i_to_id(grid_map.local_to_map(end_pos))
	var path = astar.get_point_path(start_id, end_id)
	
	var cube_mesh = create_red_cube_mesh()
	
	if path.size() > 0:
		#print("Path found:")
		for point in path:
			#print(point)
			# Create a MeshInstance3D for each point in the path
			var cube_instance = MeshInstance3D.new()
			cube_instance.mesh = cube_mesh
			cube_instance.transform.origin = point + Vector3(0, 0, 0) # Place one unit above
			add_child(cube_instance)
	else:
		pass
		#print("No path found between the specified points.")
