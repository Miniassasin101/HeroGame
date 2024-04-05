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
	Planning.contest()
	WorldState.contestie()

# Function to select a target based on your criteria (e.g., closest enemy, lowest health)
func perform_attack(attacker: UnitStatsResource, defender: StatBlockResource):
	if attacker.ap < 1:
		print(attacker.name + " does not have enough action points to attack.")
		return
		# Consume 1 AP for the attack
	print("Attack AP Cost Commencing")
	attacker.ap -= 1
	# Determine if the attack hits
	var hit_chance = calculate_hit_chance(attacker, defender)
	var does_hit = randi() % 100 < hit_chance
	
	# Calculate damage if the attack hits
	if does_hit:
		var damage = calculate_damage(attacker, defender)
		# Apply damage to the defender
		defender.current_hp -= damage
		emit_signal("attack_executed", attacker.name, defender.name, damage)
		
		# Check if the defender is defeated
		if defender.current_hp <= 0:
			emit_signal("combat_ended", attacker.name)

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
	print("Range: ")
	print(UnitBus.character_roster[LevelBus.selected_unit].equipped_weapon.range)
	return(UnitBus.character_roster[LevelBus.selected_unit].equipped_weapon.range)
	
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
	print("Battle Forecast Activating")
	print(target_name)
	LevelBus.selected_target = target_name
	var attacker_stats = UnitBus.character_roster[LevelBus.selected_unit]
	var defender_stats = WorldState.enemy_roster[target_name]

	var attacker_forecast = calculate_combat_forecast(attacker_stats, defender_stats)
	#var defender_forecast = calculate_combat_forecast(defender_stats, attacker_stats)
	print("Attacker Forecast: ")
	print(attacker_forecast)

	# Assuming ActionList is an autoloaded singleton for simplicity
	var actionlist = $"../../UI/Action List"
	actionlist.display_combat_forecast(attacker_forecast)




func calculate_hit_chance(attacker, defender) -> int:
	# Example calculation, should be adjusted based on your game's rules
	var attacker_accuracy = attacker.technique + calculate_modifier(attacker.mind)
	var defender_evasion = defender.movement + calculate_modifier(defender.mind)
	return max(0, attacker_accuracy - defender_evasion + 50) # Base 50% chance modified by stats


func calculate_damage(attacker, defender) -> int:
	# Use the equipped weapon's damage dice and attacker's strength for damage calculation
	if attacker.equipped_weapon:
		var weapon = attacker.equipped_weapon
		print("Weapon Name: ")
		print(weapon.name)
		var damage_dice = weapon.damage_dice
		var damage_type = weapon.damage_type
		var strength_bonus = calculate_modifier(attacker.strength)
		
		# Calculate base damage
		var damage = roll_damage(damage_dice) + strength_bonus
		print("Damage: ")
		print(damage)
		# Check for critical hit, etc., and adjust damage accordingly
		# This is simplified; you might have more complex logic
		return damage
	else:
		# Fallback if no weapon is equipped
		return roll_damage("1d4") # Unarmed or basic attack

func roll_damage(damage_dice: String) -> int:
	print("Func check")
	# Simplified example of rolling damage based on a string like "1d6"
	var parts = damage_dice.split("d")
	if parts.size() == 2:
		var count = int(parts[0])
		var sides = int(parts[1])
		var total = 0
		for i in range(count):
			print("Rolled Number:")
			total += randi() % sides + 1
			print(total)
		print("Total:")
		print (total)
		return total
	return 0

func calculate_modifier(stat_value: int) -> int:
	return floor((stat_value - 10) / 2.0)
	

# New method to calculate combat forecast
func calculate_combat_forecast(attacker: UnitStatsResource, defender: StatBlockResource) -> Dictionary:
	var forecast = {
		"attacker_name": attacker.name,
		"defender_name": defender.name,
		"hit_chance": calculate_hit_chance(attacker, defender),
		"expected_damage": 0, # Placeholder, will calculate below
		"critical_chance": calculate_critical_chance(attacker), # This requires a new method
		#"defender_counter_chance": calculate_hit_chance(defender, attacker), # Assuming counter-attacks are possible
		#"defender_expected_counter_damage": 0 # Placeholder, similar calculation as expected_damage
	}
	
	# Calculate expected damage if the attack hits
	if forecast.hit_chance > 0:
		forecast.expected_damage = calculate_expected_damage(attacker, defender)
		
	# Calculate expected counter damage if the defender can counter
	#if forecast.defender_counter_chance > 0:
	#	forecast.defender_expected_counter_damage = calculate_expected_damage(defender, attacker)
	
	return forecast
func ai_execute_combat_converter(attacker, player_name):
	var defending_player = UnitBus.character_roster[player_name]
	execute_combat(attacker, defending_player)
	print("AI Combat Activated")


func execute_combat(attacker, defender):
	
	if attacker.ap < 1:
		print(attacker.name + " does not have enough action points to attack.")
		return
		# Consume 1 AP for the attack
	print("Attack AP Cost Commencing")
	attacker.ap -= 1
	
	# First, check if the attack hits
	var hit_chance = calculate_hit_chance(attacker, defender)
	var does_hit = randi() % 100 < hit_chance

	if does_hit:
		# If the attack hits, calculate the actual damage
		var damage = calculate_damage(attacker, defender)

		# Apply the damage to the defender's current_hp
		defender.current_hp -= damage

		# Emit a signal to indicate that an attack was executed
		emit_signal("attack_executed", attacker.name, defender.name, damage)

		# Check if the defender is defeated (i.e., current_hp <= 0)
		if defender.current_hp <= 0:
			# Emit a signal to indicate that combat ended, specifying the winner
			emit_signal("combat_ended", attacker.name)
			print(defender.name + " was defeated by " + attacker.name + "!")
		else:
			print(defender.name + " now has " + str(defender.current_hp) + " HP left.")
	else:
		# If the attack does not hit, inform that the attack missed
		print(attacker.name + "'s attack missed " + defender.name + ".")


func calculate_expected_damage(attacker: UnitStatsResource, defender: StatBlockResource) -> Dictionary:
	# Simplified expected damage calculation
	var damage_range = []
	if attacker.equipped_weapon:
		var weapon = attacker.equipped_weapon
		damage_range = get_damage_range(weapon.damage_dice)
	else:
		damage_range = get_damage_range("1d4")
	var min_damage = damage_range[0]
	var max_damage = damage_range[1]
	var strength_bonus = calculate_modifier(attacker.strength)
		
	# Adjust damage range by strength modifier
	min_damage += strength_bonus
	max_damage += strength_bonus
	print("Min and max damages:")
	print(min_damage)
	print(max_damage)
	print("Expected Damage:")
	print({"min_damage": max(0, min_damage), "max_damage": max(0, max_damage)})
	return {"min_damage": max(0, min_damage), "max_damage": max(0, max_damage)}
	#possible logic for damage reduction baseed on defense stat


func get_damage_range(damage_dice: String) -> Array:
	var parts = damage_dice.split("d")
	if parts.size() == 2:
		var dice_count = int(parts[0])
		var dice_sides = int(parts[1])

		# Calculate minimum and maximum possible damage
		var min_damage = dice_count  # Minimum damage is one per die
		var max_damage = dice_count * dice_sides  # Maximum damage is the highest roll per die

		return [min_damage, max_damage]
	return [0, 0]  # Return [0, 0] if damage_dice format is incorrect

func calculate_critical_chance(attacker: UnitStatsResource) -> int:
	# Placeholder for critical hit chance calculation
	# You'll need to define how critical chances are determined in your game's rules
	return 10 # Example: 10% critical chance
