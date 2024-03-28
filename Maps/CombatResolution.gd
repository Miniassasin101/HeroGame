# CombatService.gd
#This is the script that handles and reroutes all combat related data,
#and also handles the attack prediciton calculations
extends Node

class_name CombatService

# Signals to communicate combat events
signal target_selected(target_name)
signal attack_executed(attacker_name, target_name, damage)
signal combat_ended(winner)

func _ready():
	LevelBus.connect("attack_button", Callable(self, "_target_selection"))

# Function to select a target based on your criteria (e.g., closest enemy, lowest health)
func _target_selection():
	print("Target Selection Working")
	var attack_range = find_attack_range()
	print(attack_range)
	var attacker_position = WorldState.player_positions[LevelBus.selected_unit]  # Assuming attacker is a player
	var targets = find_enemies_within_range(attacker_position, attack_range)
	# Implement target selection logic here
	if targets.size() > 0:
		print("Targets Within Range: ", targets)
	else:
		print("No targets within attack range.")
	


func find_attack_range():
	UnitBus.character_roster[LevelBus.selected_unit].update_derived_stats()
	return(UnitBus.character_roster[LevelBus.selected_unit].range)
	
# Method to find all enemies within range of an attack
func find_enemies_within_range(attacker_position: Vector3, attack_range: int) -> Array:
	var targets = []  # This will hold the names of all targets within range
	for x in range(-attack_range, attack_range + 1):
		for z in range(-attack_range, attack_range + 1):
			# Calculate the potential target position
			var target_position = attacker_position + Vector3(x, 0, z)
			# Ensure we're looking within a circular (or spherical) area, not a square
			if target_position.distance_to(attacker_position) <= attack_range:
				var enemy_name = WorldState.get_enemy_name_by_position(target_position)
				if enemy_name != "":
					# Add the found enemy to the targets list
					targets.append(enemy_name)
	send_targets_to_ui(targets)
	return targets

func send_targets_to_ui(targets):
	print("Targets sent to ui: ", targets)
	var action_list = $"../../UI/Action List"
	action_list.create_target_buttons(targets)

func handle_target_selected(target_name):
	print("Target ", target_name, " has been selected for the attack.")
	battle_forecast(target_name)

func battle_forecast(target_name):
	LevelBus.selected_target = target_name
	var attacker_stats = UnitBus.character_roster[LevelBus.selected_unit]
	var defender_stats = WorldState.enemy_roster[target_name]

	var attacker_forecast = calculate_combat_forecast(attacker_stats, defender_stats)
	var defender_forecast = calculate_combat_forecast(defender_stats, attacker_stats)
	print(attacker_forecast)

	# Assuming ActionList is an autoloaded singleton for simplicity
	var actionlist = $"../../UI/Action List"
	actionlist.display_combat_forecast(attacker_forecast, defender_forecast)

func calculate_combat_forecast(attacker_stats, defender_stats) -> Dictionary:
	var forecast = {
		"new_current_hp": max(0, attacker_stats.current_hp - (defender_stats.physical_attack - attacker_stats.defense)),
		"physical_damage": max(0, attacker_stats.physical_attack - defender_stats.defense),
		"displayed_hit": max(0, attacker_stats.hit_chance - defender_stats.avoidance),
		"displayed_crit": max(0, attacker_stats.critical_chance - defender_stats.dodge)
	}
	
	return forecast

func execute_combat():
	# Here, you would use the previously calculated forecast data
	# to adjust the stats of the attacker and defender, simulate combat, etc.
	# For example:
	print("Executing combat between", LevelBus.selected_unit, "and", LevelBus.selected_target)
	var attacker_name = LevelBus.selected_unit
	var defender_name = LevelBus.selected_target  # This should be set when a target button is pressed
	var attacker_stats = UnitBus.character_roster[attacker_name]
	var defender_stats = WorldState.enemy_roster[defender_name]
	
	# Get forecasts to perform combat calculations
	var attacker_forecast = calculate_combat_forecast(attacker_stats, defender_stats)
	var defender_forecast = calculate_combat_forecast(defender_stats, attacker_stats)
	
	# Attacker's turn
	if true_hit(attacker_forecast["displayed_hit"]):
		var damage_dealt = attacker_forecast["physical_damage"]
		if randi() % 100 < attacker_forecast["displayed_crit"]:
			damage_dealt *= 2  # Critical hit doubles damage
			print("Critical Hit!")
		defender_stats.current_hp = max(0, defender_stats.current_hp - damage_dealt)
		print("Attacker hit! Defender's new HP: ", defender_stats.current_hp)
	else:
		print("Attacker missed!")
	
	# Defender's turn (if in range and alive)
	if defender_stats.current_hp > 0:# and attacker_stats.range <= defender_stats.range:
		if true_hit(defender_forecast["displayed_hit"]):
			var damage_dealt = defender_forecast["physical_damage"]
			if randi() % 100 < defender_forecast["displayed_crit"]:
				pass
				damage_dealt *= 2  # Critical hit doubles damage
			attacker_stats.current_hp = max(0, attacker_stats.current_hp - damage_dealt)
			print("Defender hit! Attacker's new HP: ", attacker_stats.current_hp)
		else:
			print("Defender missed!")
	
	# Emit signals based on combat outcome, for example:
#	emit_signal("attack_executed", attacker_name, defender_name, damage_dealt)
	if attacker_stats.current_hp <= 0 or defender_stats.current_hp <= 0:
		emit_signal("combat_ended", attacker_name if defender_stats.current_hp <= 0 else defender_name)

# CombatService.gd

# True Hit calculation based on displayed hit chance
func true_hit(displayed_hit: int) -> bool:
	var rand1 = randi() % 100
	var rand2 = randi() % 100
	var true_hit_chance = (rand1 + rand2) / 2.0
	return true_hit_chance < displayed_hit

