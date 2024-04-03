extends Node

@onready var controller = get_parent()
@onready var enemy_count = {}  # A dictionary to keep track of the number of each type of enemy
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
	var startpos = Vector3(ranx + 0.5, 1, 3.5)
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
