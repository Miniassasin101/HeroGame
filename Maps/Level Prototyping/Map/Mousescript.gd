extends Node3D

# Assign your Camera3D and GridMap nodes in the inspector or find them in _ready().

@onready var camera_3d = $Player/Camera3D
@onready var sprite_3d = $Player/Sprite3D


func _ready():
	# Make sure the input processing is enabled.
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get the mouse click position.
		var mouse_position = event.position
		# Perform the raycast from the camera's perspective.
		cast_ray(mouse_position)

func cast_ray(screen_pos):
	var space_state = get_world_3d().direct_space_state
	
	# Convert screen position to raycast starting and ending points.
	var ray_origin = camera_3d.project_ray_origin(screen_pos)
	var ray_end = ray_origin + camera_3d.project_ray_normal(screen_pos) * 1000
	
	# Perform the raycast.
	var result = space_state.intersect_ray.bind(ray_origin, ray_end, [self], 0b11111111111111111111111111111111, true, true)
	
	if result:
		# If the ray hit something, get the collision point.
		var hit_position = result.position
		# Convert the hit position to GridMap coordinates.
		var map_position = grid_map.local_to_map(hit_position)
		print("Hit grid map at: ", map_position)
