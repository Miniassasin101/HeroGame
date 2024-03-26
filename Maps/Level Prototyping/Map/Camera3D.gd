#Camera3D.gd
#This script handles camera movement and ray-based input picking with the mouse. 
#There is additional logic to appropriately round/adjust the reported position that the mouse clicks so it registers as having clicked on a specific position.
extends Camera3D



@onready var character = $"../Sprite3D"
@onready var grid_map = $"../../Tilemaps/GridMap"
var speed = 7.0
var ray_length = 100
func _ready():
	
	pass

func _input(event):
	if LevelBus.menu_toggle1 == "move":
		if event.is_action_pressed("move"):
			var adjusted_positition = shoot_ray()
			LevelBus.mousesave(adjusted_positition)
			LevelBus.menu_toggle1 = "wait"
	else:
		pass

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	print("mouse_pos:")
	print(mouse_pos)
	var from = project_ray_origin(mouse_pos)
	print("from: ")
	print(from)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	print("to: ")
	print(to)
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	print(ray_query)
	var intersection = get_world_3d().direct_space_state.intersect_ray(ray_query)
	print("intersection: ")
	print(intersection)
	if intersection:
		print("Pos Result")
		print(intersection.position)
		var intersection_pos = intersection.position
		var adjusted_x = round_to_nearest_half(intersection_pos.x)
		var adjusted_z = round_to_nearest_half(intersection_pos.z)
		var adjpos = Vector3(adjusted_x, intersection_pos.y, adjusted_z)
		print("Calculation Test:")
		print (adjpos)
		print("Calc Test Success")
		return adjpos
		#Call the function in the parent script with the clicked world position

#adjusting/rounding function
func round_to_nearest_half(value):
	# Round a value to the nearest 0.5, never to a whole number.
	var rounded = round(value * 2) / 2  # Round to nearest 0.5
	if rounded == int(rounded):  # If it's a whole number
		if value > rounded:  # If original value was above the whole number, round up
			return rounded + 0.5
		else:  # If original value was below the whole number, round down
			return rounded - 0.5
	return rounded

#camera moving function
func _process(delta):
	var move_vector = Vector3.ZERO  # Initialize movement vector
	# Check input and adjust movement vector accordingly
	if Input.is_action_pressed("ui_right"):  # D or Right Arrow
		move_vector.x += 1
	if Input.is_action_pressed("ui_left"):  # A or Left Arrow
		move_vector.x -= 1
	if Input.is_action_pressed("ui_up"):  # S or Down Arrow
		move_vector.y += 1
	if Input.is_action_pressed("ui_down"):  # W or Up Arrow
		move_vector.y -= 1

	move_vector = move_vector.normalized() * speed * delta  # Normalize and scale by speed and delta time

	# Move the camera
	translate(move_vector)
