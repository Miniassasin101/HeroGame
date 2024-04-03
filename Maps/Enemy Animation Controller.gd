extends Node

@onready var controller = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
#Places a sprite in the game world based on the character's name that it's given
#func _initialize_sprite():
	print("About to intitialize the enemy Faceless sprite")
	var sprite_3d = Sprite3D.new()
	var texture_path = "res://Maps/Level Prototyping/sprites/Wolf3.png"
	var texture = load(texture_path)
	var sprite_name = "Wolf"
	if texture:
		sprite_3d.texture = texture
	else:
		print("Failed to load texture at path: " + texture_path)
	sprite_3d.set_billboard_mode(1)
	var ranx = randi_range(2, 3) 
	var startpos = Vector3(ranx + 0.5, 1, 3.5)
	var updpos = startpos# + Vector3(-0.25, 0, -0.25)
	sprite_3d.set_position(startpos)
	#Reminder: add logic later to set the name of the node equal to the character's name
	sprite_3d.set_name(sprite_name)
	# Example of updating a player unit's position
	WorldState.update_unit_position(sprite_name, updpos, true)
	var parent = get_parent()
	parent.write_position_to_blackboard(startpos)
	var grandparent = get_parent().get_parent()  # Access the grandparent node
	if grandparent and grandparent.has_method("set_node_name"):
		grandparent.set_node_name(sprite_name)
	else:
		print("Grandparent does not exist or does not have the 'set_node_name' method.")
	add_child(sprite_3d)
