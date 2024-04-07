extends Node

@onready var controller = get_parent()
@onready var enemy_count = {}  # A dictionary to keep track of the number of each type of enemy
@onready var duration_per_segment = 0.3 # Adjust based on how fast you want the sprite to move
# Called when the node enters the scene tree for the first time.
func _ready():
#Places a sprite in the game world based on the character's name that it's given

	print("About to intitialize the enemy Wolf sprite")
	var sprite_3d = Sprite3D.new()
	var texture_path = "res://Maps/Level Prototyping/sprites/Wolf3.png"
	var texture = load(texture_path)
	var sprite_name = "Wolf"
	if texture:
		sprite_3d.texture = texture
	else:
		print("Failed to load texture at path: " + texture_path)
	sprite_3d.set_billboard_mode(1)
	var ranx = randi_range(2, 6) 
	var rany = randi_range(2, 6)
	var startpos = Vector3(ranx + 0.5, 1, rany + 0.5)
	var updpos = startpos# + Vector3(-0.25, 0, -0.25)
	sprite_3d.set_position(startpos)
	#Reminder: add logic later to set the name of the node equal to the character's name
	# Construct the unique name using the type and count
	if sprite_name in enemy_count:
		enemy_count[sprite_name] += 1
		print("Enemy Count")
		print(enemy_count[sprite_name])
	else:
		print("Enemy Count Name")
		enemy_count[sprite_name] = 1
		
	if WorldState.enemy_count.has(sprite_name):
		WorldState.enemy_count[sprite_name] += 1
	else:
		WorldState.enemy_count[sprite_name] = 1
		
	var char_name = "%s %d" % [sprite_name, WorldState.enemy_count[sprite_name]]
	sprite_3d.set_name(char_name)
	# Example of updating a player unit's position
	WorldState.update_unit_position(char_name, updpos, true)
	var parent = get_parent()
	parent.write_position_to_blackboard(startpos)
	var grandparent = get_parent().get_parent()  # Access the grandparent node
	if grandparent and grandparent.has_method("set_node_name"):
		grandparent.set_node_name(char_name)
	else:
		print("Grandparent does not exist or does not have the 'set_node_name' method.")
	add_child(sprite_3d)

func move_ai_unit_along_path(path: PackedVector3Array, enemy_name: String, unit_name: String):
	# Check if the path is not empty and unit_name is valid
	print("Move Ai Along Path Names")
	print(unit_name)
	print(enemy_name)
	var duration_per_segment = 0.3 # Adjust based on how fast you want the sprite to move

	# Access the Unit's AnimationController to get the Sprite3D
	var animation_controller_path = "Combatants/Opponent Combatant Group/%s/Controllers/Animation Controller" % enemy_name
	var animation_controller = get_node("../../..").get_node(animation_controller_path)
	var btpath = "Combatants/Opponent Combatant Group/%s/Controllers/AI Controller/BTPlayer" % enemy_name
	var bt = get_node("../../..").get_node(btpath)

	# Check if the animation controller and Sprite3D node exist
	if not animation_controller or not animation_controller.has_node(unit_name):
		print("Animation Controller or Sprite3D does not exist for unit: ", unit_name)
		return
	# Get the actual Sprite3D to move
	var sprite_to_move = animation_controller.get_node(unit_name)
	print("Stm")
	print(sprite_to_move)
	# Create a tween to move the Sprite3D
	var tween = get_tree().create_tween()
	for i in range(path.size() - 1):
		var from_position = path[i]
		var to_position = path[i + 1]

		# Adjust the to_position if necessary, based on how your game handles coordinates
		var actual_to_position = to_position + Vector3(-.15, 1, -.15) # Adjust Y-axis as per your game's needs
		var reg_to_position = to_position + Vector3(0, 0, 0)
		print("We're Half-way thereee")
		# Animate the sprite from its current position to the next one in the path
		tween.tween_property(sprite_to_move, "position", Vector3(actual_to_position), duration_per_segment).set_trans(0).set_ease(2)
		WorldState.update_unit_position(unit_name, reg_to_position, true)
		#bt.set_bb_pos_var(reg_to_position)
		print(reg_to_position)
		# If not the last segment, chain the next movement
		if i < path.size() - 2:
			tween.chain()
	tween.play()
	#update_astar_based_on_units()

func move_ai_unit(unit_path, unit_name):
	print("Move Ai Unit Working")
	print("Moving unit along path:", unit_name)
	if unit_path.size() == 0:
		print("Path is empty:", unit_name)
		return
		
	var reg_to_position = true
	var sprite_to_move = get_child(0)
	print("Sprite to move:", sprite_to_move)
	var tween = get_tree().create_tween()
	for i in range(unit_path.size() - 1):
		var from_position = unit_path[i]
		var to_position = unit_path[i + 1]
		# Adjust positions as needed
		var actual_to_position = to_position + Vector3(-.15, 1, -.15)	# Example adjustment
		reg_to_position = to_position + Vector3(0, 0, 0)
		# Animate sprite movement
		tween.chain().tween_property(sprite_to_move, "position", Vector3(actual_to_position), \
		duration_per_segment).set_trans(4).set_ease(2)
		WorldState.update_unit_position(unit_name, reg_to_position, true)
		#if i < unit_path.size() - 2:
		#	tween.chain()
	tween.play()
	print("Animation Complete")
		
