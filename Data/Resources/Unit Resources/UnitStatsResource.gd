# UnitStatsResource.gd
extends Resource
class_name UnitStatsResource
signal experience_gained(character_name)
@export var name: String
@export var title: String
@export var level: int = 1
@export var internal_level: int = 1
@export var experience: int = 0
@export var current_class: String

#Base Stats
@export_group("Base_Stats")
@export var hp: int = 15
@export var current_hp: int = 15
@export var ap: int = 3
@export var build: int = 3
@export var movement: int = 3
@export var strength: int = 5
@export var magic: int = 5
@export var dexterity: int = 5
@export var skill: int = 6
@export var speed: int = 5
@export var luck: int = 5
@export var defense: int = 5
@export var resistance: int = 5
@export_subgroup("Derived_Stats")
@export var rating: int = 0
@export var might: int = 13
@export var hit: int = 21
@export var critical: int = 1
@export var physical_attack: int = 21
@export var magic_attack: int = 25
@export var avoidance: int = 21
@export var critical_chance: int = 2
@export var dodge: int = 21
@export var range: int = 1
@export var hit_chance: int = 34
@export_group("")
@export var equipped_weapon: WeaponStatsResource
@export var equipped_items: Array[String]
@export var known_skills: Array[String]
@export var equipped_skills: Array[String]
@export var actions: Array[ActionResource] = []


var growth_rates = {
	"HP": 25,  # Percent chance to increase on level up
	"Strength": 60,
	"Magic": 60,
	"Skill": 50,
	"Dexterity": 100,
	"Speed": 40,
	"Luck": 60,
	"Defense": 60,
	"Resistance":60,
	"Movement": 0  # Typically does not grow on level up
}

func gain_experience(exp: int):
	experience += exp
	while experience >= 100:
		experience -= 100
		level_up()
	#check_for_level_up()
	#emit_signal("experience_gained", name)  # Ensure the character's name is passed with the signal





func level_up():
	if level < 20:  # Check for level cap
		level += 1
		internal_level += 1
		apply_growth_rates()
	else:
		print("Max level reached")

func apply_growth_rates():
# Directly increase stats based on growth rates
	if randi() % 100 < growth_rates["HP"]:
		hp += 1
		current_hp += 1
	if randi() % 100 < growth_rates["Strength"]:
		strength += 1
	if randi() % 100 < growth_rates["Magic"]:
		magic += 1
	if randi() % 100 < growth_rates["Skill"]:
		skill += 1
	if randi() % 100 < growth_rates["Dexterity"]:
		dexterity += 1
	if randi() % 100 < growth_rates["Speed"]:
		speed += 1
	if randi() % 100 < growth_rates["Luck"]:
		luck += 1
	if randi() % 100 < growth_rates["Defense"]:
		defense += 1
	if randi() % 100 < growth_rates["Resistance"]:
		resistance += 1
# Note: Movement typically does not increase on level up
# Call this when promoting a unit
func promote():
	level = 1
	internal_level = (internal_level + 20) / 2
	# You might also adjust growth_rates and base_stats here based on the new class
func calculate_experience_gain(enemy_level: int, is_victory: bool):
	# Simplified version; adjust based on your game's rules
	var level_difference = enemy_level - internal_level
	var exp_gain = max(1, 50 + level_difference * 5)  # Basic formula; adjust as needed
	if is_victory:
		gain_experience(exp_gain)

# Calculate stats based on the equipped weapon

func calculate_crit():
	return (equipped_weapon.crit if equipped_weapon else 0)
func calculate_physical_attack():
	return strength + (equipped_weapon.might if equipped_weapon else 0)
func calculate_magic_attack():
	return magic + (equipped_weapon.might if equipped_weapon else 0)
func calculate_rating():
# Assuming 'build' is also part of base stats for simplicity
	return strength + magic + skill + speed + luck + defense + resistance + build
func calculate_hit_chance():
	return (equipped_weapon.hit if equipped_weapon else 0) + ((skill * 3 + luck) / 2)
func calculate_avoidance():
	return (speed * 3 + luck) / 2 - (equipped_weapon.weight if equipped_weapon else 0)
func calculate_critical_chance():
	return (equipped_weapon.crit if equipped_weapon else 0) + (skill / 2)
func calculate_dodge():
	return luck
func calculate_range():
# Assuming weapon range is a simple value in the weapon resource
	return (equipped_weapon.range if equipped_weapon else 1)

func calculate_current_stats():
	calculate_rating()
	calculate_crit()
	calculate_physical_attack()
	calculate_magic_attack()
	calculate_hit_chance()
	calculate_avoidance()
	calculate_critical_chance()
	calculate_dodge()
	calculate_range()

func _init():
	calculate_current_stats()
	  # Initial calculation
func apply_modifiers():
# This function applies modifiers and recalculates stats
	calculate_current_stats()
	

# Other Updates (assuming they are needed to be called outside)
func update_health(current: int, max: int):
	hp = current
# Assuming you have a max health variable
# max_hp = max
func update_mana(current_mana: int):
	pass
	#mana = current_mana
	
func update_build(new_build: int):
	build = new_build
	apply_modifiers()  # Recalculate since build affects other stats

func update_derived_stats():
	print("Derived stat updating")
	physical_attack = calculate_physical_attack()
	magic_attack = calculate_magic_attack()
	rating = calculate_rating()
	hit_chance = calculate_hit_chance()
	avoidance = calculate_avoidance()
	critical_chance = calculate_critical_chance()
	dodge = calculate_dodge()
	range = calculate_range()
	critical = calculate_crit()
	print("Printing Range")
	print(range)
