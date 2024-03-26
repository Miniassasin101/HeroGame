#Player Combatant Group
#this script manages it's unit node children and routes to them any unit specific data.
extends Node

# Dictionary to hold combatant names.
var combatants = {}
# Counter to keep track of the units.
var unit_counter = 0
@onready var unit_key = true
signal unit_name_assigned(unit_key, name)


func _ready():
	UnitBus.connect("PCName", Callable(self, "_on_PCName_received"))

#Work in progress function for bringing up a Menu for the player so they can select one of the actions a unit has avalable to them.
func _input(event):
	#Unit 1 hotkey
	if event.is_action_pressed("Unit 1 Actions"):
		LevelBus.menu_toggle1 = "actio/ns"
		var unit_key = "Unit 1"
		LevelBus.unit_key = unit_key
		LevelBus.selected_unit = combatants[unit_key]
		print("in actions mode and selected unit is: " + LevelBus.selected_unit)
		
		#Unit 2 hotkey
	if event.is_action_pressed("Unit 2 Actions"):
		LevelBus.menu_toggle1 = "actions"
		var unit_key = "Unit 2"
		LevelBus.unit_key = unit_key
		LevelBus.selected_unit = combatants[unit_key]
		print("in actions mode and selected unit is: " + LevelBus.selected_unit)
		
		#Unit 3 hotkey
	if event.is_action_pressed("Unit 3 Actions"):
		LevelBus.menu_toggle1 = "actions"
		var unit_key = "Unit 3"
		LevelBus.unit_key = unit_key
		LevelBus.selected_unit = combatants[unit_key]
		print("in actions mode and selected unit is: " + LevelBus.selected_unit)
		
		

# Function to add a combatant's name to the dictionary under a unique key.
func _on_PCName_received(name: String):
	print("Signal Recieved")
	
	unit_counter += 1  # Increment the unit counter.
	var unit_key = "Unit " + str(unit_counter)  # Generate a unique key.
	combatants[unit_key] = name  # Add the combatant's name under the generated key.
	print(combatants)
	emit_signal("unit_name_assigned", unit_key, name)  # Emit the signal with the unit key and name.

