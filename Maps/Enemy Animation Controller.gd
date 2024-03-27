extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
#Places a sprite in the game world based on the character's name that it's given
#func _initialize_sprite():
	print("About to intitialize the enemy Faceless sprite")
	var sprite_3d = Sprite3D.new()
	var texture_path = "res://Maps/Level Prototyping/sprites/FacelessP.png"
	var texture = load(texture_path)
	var sprite_name = "Dio"
	if texture:
		sprite_3d.texture = texture
	else:
		print("Failed to load texture at path: " + texture_path)
	sprite_3d.set_billboard_mode(1)
	var ranx = randi_range(2, 6) 
	var startpos = Vector3(ranx + 0.75, 1, 3.75)
	var updpos = startpos + Vector3(-0.25, 0, -0.25)
	sprite_3d.set_position(startpos)
	#Reminder: add logic later to set the name of the node equal to the character's name
	sprite_3d.set_name(sprite_name)
	# Example of updating a player unit's position
	WorldState.update_unit_position(sprite_name, updpos, true)
	add_child(sprite_3d)
