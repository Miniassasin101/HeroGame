#Action List.gd
#control node that manages the buttons that allow a player to select actions for the selected unit.
extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ActionList.gd

func display_combat_forecast(attacker_forecast, defender_forecast):
	var vbox = $"Control/Attack Options/VBoxContainer"
	vbox.show()  # Clear existing content
	for n in vbox.get_children():
		vbox.remove_child(n)
		n.queue_free()
	
	
	create_forecast_row("HP", attacker_forecast["new_current_hp"], defender_forecast["new_current_hp"])
	create_forecast_row("Atk", attacker_forecast["physical_damage"], defender_forecast["physical_damage"])
	create_forecast_row("Hit", attacker_forecast["displayed_hit"], defender_forecast["displayed_hit"])
	create_forecast_row("Crit", attacker_forecast["displayed_crit"], defender_forecast["displayed_crit"])
	
	# Handle player confirmation
	var confirm_button = Button.new()
	confirm_button.text = "Confirm Attack"
	confirm_button.pressed.connect(_on_confirm_attack_pressed)
	vbox.add_child(confirm_button)
	
func _on_confirm_attack_pressed():
	# Signal CombatService to execute the combat
	var comser = $"../../Services/Combat Service"
	comser.execute_combat()

# Helper function to create UI elements
func create_forecast_row(title, attacker_value, defender_value):
	var hbox = HBoxContainer.new()
	var attacker_label = Label.new()
	var title_label = Label.new()
	var defender_label = Label.new()

	attacker_label.text = str(attacker_value)
	title_label.text = title
	defender_label.text = str(defender_value)

	hbox.add_child(attacker_label)
	hbox.add_child(title_label)
	hbox.add_child(defender_label)
	var vbox = $"Control/Attack Options/VBoxContainer"

	vbox.add_child(hbox)

	# Populate the UI with forecast data







func create_target_buttons(targets):
	var vbox = $"Control/Attack Options/VBoxContainer"

	 # Clear existing buttons if any
	for target in targets:
		var button = Button.new()
		button.text = target
		
		button.pressed.connect(_on_target_button_pressed.bind(button.text))
		vbox.add_child(button)

func _on_target_button_pressed(target_name):
	# Here you send back the selected target to the Combat Service or handle as needed
	print("Selected target: ", target_name)
	# Assuming CombatService is an autoloaded singleton
	var comser = $"../../Services/Combat Service"

	comser.handle_target_selected(target_name)

func _on_move_button_pressed():
	LevelBus.menu_toggle1 = "move"
	print("in move mode and selected unit is: " + LevelBus.selected_unit)
	LevelBus._move_button()
	
func _on_attack_button_pressed():
	LevelBus.menu_toggle1 = "attack"
	print("Attack Button Pressed")
	LevelBus._attack_button()
	
