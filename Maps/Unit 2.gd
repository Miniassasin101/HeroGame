# Child Unit script
extends Node

func _ready():
	# Assuming the script is a direct child of the Player Combatant Group
	# Adjust the path if your structure is different
	var parent_group = get_parent()
	parent_group.connect("unit_name_assigned", Callable(self, "_on_unit_name_assigned"))

func _on_unit_name_assigned(unit_key: String, name: String):
	if name in get_parent().combatants.values():
		# Assign the name only if it matches this unit's assigned name in the dictionary
		self.name = name  # or any other property you use to store the unit's name
		print(self.name)
