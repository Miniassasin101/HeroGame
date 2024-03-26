#Animation Controller.gd
#Script is shared between all units, so relies on the combatants dictionary in Player Combatant group to make sure any changes are unit-specific.
extends Node

# Variable to hold the start position

# Variable to hold the scale of the Sprite3D
@export var sprite_scale: Vector3 = Vector3.ONE



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Places a sprite in the game world based on the character's name that it's given
func _initialize_sprite(sprite_name: String):
	print("About to intitialize the sprite for: " + sprite_name)
	
	var sprite_3d = Sprite3D.new()
	var texture_path = "res://Maps/Level Prototyping/sprites/" + sprite_name + ".png"
	var texture = load(texture_path)
	if texture:
		sprite_3d.texture = texture
	else:
		print("Failed to load texture at path: " + texture_path)
	sprite_3d.set_billboard_mode(1)
	var ranx = randi_range(2, 6) 
	var startpos = Vector3(ranx, 1, 5)
	sprite_3d.set_position(startpos)
	#Reminder: add logic later to set the name of the node equal to the character's name
	sprite_3d.set_name(sprite_name)
	add_child(sprite_3d)

	
	



func update_name(character: String):
	# Here, we're simply printing the new name to the console
	print("Animation Controller received new name: " + character)
	# You can add additional logic here to update animations or properties based on the new name
	_initialize_sprite(character)
