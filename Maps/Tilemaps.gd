extends Node
@onready var gridmap_node = $LevelProto

# Get the global transform of the GridMap
@onready var global_transform = gridmap_node.global_transform

func _ready():
	
	if global_transform.origin == Vector3.ZERO:
		print("GridMap starts at (0, 0, 0) in world space.")
	else:
		print("GridMap does not start at (0, 0, 0). It starts at: ", global_transform.origin)
