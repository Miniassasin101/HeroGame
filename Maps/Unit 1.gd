#Unit 1.gd
#Child Unit script
#Script is shared between all units, so relies on the combatants dictionary in Player Combatant group to make sure any changes are unit-specific.
#This script also passes information to it's children nodes and controllers
extends Node

func _ready():
	# The script is a direct child of the Player Combatant Group
	# Adjust the path if your structure is different
	var parent_group = get_parent()
	parent_group.connect("unit_name_assigned", Callable(self, "_on_unit_name_assigned"))

func _on_unit_name_assigned(unit_key: String, name: String):
	if self.name == unit_key:
		var new_name = name
		print("Updated " + self.name + " with new name: " + new_name)
		#Name Passer
		_pass_name_to_animation_controller(new_name)
		# Perform additional actions as needed, such as updating UI elements or triggering animations

#Uses name of unit to pass associated character name to Animation Controller.
func _pass_name_to_animation_controller(new_name: String):
	# Construct the path to the Animation Controller node
	var path_to_animation_controller = "../" + self.name + "/Controllers/Animation Controller"
	print("AC Path: " + path_to_animation_controller)
	var animation_controller = get_node(path_to_animation_controller)
	print(animation_controller)
	if animation_controller:
		# Call a method on the Animation Controller to update with the new name
		animation_controller.update_name(new_name)
		pass
	else:
		print("Animation Controller not found for " + self.name)
