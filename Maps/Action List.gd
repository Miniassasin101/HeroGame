#Action List.gd
#control node that manages the buttons that allow a player to select actions for the selected unit.
extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ActionList.gd

func display_combat_forecast(attacker_forecast):
	var vbox = $"Control/Attack Options/VBoxContainer"
	# Clear existing content
	for n in vbox.get_children():
		vbox.remove_child(n)
		n.queue_free()
	#var attack_options = $"Control/Attack Options"
	#attack_options.set_visible(true)
	
	create_forecast_row("Attacker", attacker_forecast["attacker_name"], "")
	create_forecast_row("Defender", attacker_forecast["defender_name"], "")
	create_forecast_row("Hit Chance", str(attacker_forecast["hit_chance"]) + "%", "")
	var dmg_range_text = str(attacker_forecast["expected_damage"]["min_damage"]) + " - " + str(attacker_forecast["expected_damage"]["max_damage"])
	create_forecast_row("Damage:", dmg_range_text, "")
	create_forecast_row("Crit Chance", str(attacker_forecast["critical_chance"]) + "%", "")
	
	# Handle player confirmation
	var confirm_button = Button.new()
	confirm_button.text = "Confirm Attack"
	confirm_button.pressed.connect(_on_confirm_attack_pressed)
	vbox.add_child(confirm_button)
	


# Helper function to create UI elements
func create_forecast_row(title, attacker_value, defender_placeholder):
	var hbox = HBoxContainer.new()
	var attacker_label = Label.new()
	var title_label = Label.new()
	#var defender_label = Label.new()

	attacker_label.text = str(attacker_value)
	title_label.text = title
	#defender_label.text = str(defender_value)
	
	hbox.add_child(title_label)
	hbox.add_child(attacker_label)
	
	#hbox.add_child(defender_label)
	var vbox = $"Control/Attack Options/VBoxContainer"

	vbox.add_child(hbox)

	# Populate the UI with forecast data





func _on_confirm_attack_pressed():
	# Signal CombatService to execute the combat
	var comser = $"../../Services/Combat Service"
	var vbox = $"Control/Attack Options/VBoxContainer"
	#vbox.hide()  # Clear existing content
	#var attack_options = $"Control/Attack Options"
	#attack_options.set_visible(false)
	for n in vbox.get_children():
		vbox.remove_child(n)
		n.queue_free()
	comser.execute_combat(UnitBus.character_roster[LevelBus.selected_unit], WorldState.enemy_roster[LevelBus.selected_target])


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
	var moving_unit = UnitBus.character_roster[LevelBus.selected_unit]
	if moving_unit.ap < 1:
		print(moving_unit.name + " does not have enough action points to move.")
		return
		# Consume 1 AP for the attack
	print("Attack AP Cost Commencing")
	moving_unit.ap -= 1
	if LevelBus.turn == "player":
		LevelBus.menu_toggle1 = "move"
		print("in move mode and selected unit is: " + LevelBus.selected_unit)
		LevelBus._move_button()
	else:
		print("Wait Your Turn")
func _on_attack_button_pressed():
	if LevelBus.turn == "player":
		LevelBus.menu_toggle1 = "attack"
		print("Attack Button Pressed")
		LevelBus._attack_button()
	else:
		print("Wait Your Turn")
	
