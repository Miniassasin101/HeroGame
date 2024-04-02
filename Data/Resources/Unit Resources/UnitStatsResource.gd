# UnitStatsResource.gd
extends Resource
class_name UnitStatsResource
signal experience_gained(character_name)

@export var name: String
@export var title: String
@export var rank: int = 1
@export var internal_level: int = 1
@export var experience: int = 0
@export var current_class: String

# Base Core Stats
@export var life: int = 2
@export var mind: int = 2
@export var spirit: int = 2
@export var nature: int = 2
# Derived Stats (initialized based on core stats)
@export var vigor: int = 12  # Life-based, example starting value
@export var strength: int = 12  # Life-based
@export var technique: int = 12  # Mind-based
@export var insight: int = 12  # Mind-based
@export var will: int = 12  # Spirit-based
@export var conviction: int = 12  # Spirit-based

#Base Stats
@export var hp: int = 15
@export var current_hp: int = 15
@export var ap: int = 3
@export var movement: int = 3

@export var traits: Array[String] = []


@export var equipped_weapon: WeaponStatsResource
@export var equipped_items: Array[String]
@export var known_skills: Array[String]
@export var actions: Array[ActionResource] = []

func calculate_modifier(stat_value: int) -> int:
	return floor((stat_value - 10) / 2.0)

func gain_experience(exp: int):
	experience += exp
	while experience >= 100:
		experience -= 100
		rank_up()


func use_skill(skill_name: String, target = null):
	if skill_name in known_skills:
		# Example: Check if the skill aligns with the character's Nature
		var nature_bonus = 0
		if skill_name in character_nature_aligned_skills():
			nature_bonus = calculate_nature_bonus()
			print("Using skill aligned with Nature:", skill_name, "-> Bonus applied")
		elif skill_name in character_nature_opposed_skills():
			nature_bonus = calculate_nature_penalty()
			print("Using skill opposed to Nature:", skill_name, "-> Penalty applied")
		
		# Apply skill effects here, modified by nature_bonus if applicable
	else:
		print("Skill not known or equipped:", skill_name)

func reset_ap():
	ap = 3  # Resetting AP to its maximum

# Consume AP for an action
func consume_ap(character: UnitStatsResource, cost: int) -> bool:
	if character.ap >= cost:
		character.ap -= cost
		print(character.name + " uses " + str(cost) + " AP. " + str(character.ap) + " AP remaining.")
		return true
	else:
		print(character.name + " does not have enough AP to perform this action.")
		return false

func character_nature_aligned_skills() -> Array:
	# Return an array of skill names that align with the character's Nature
	# This should be customized based on the character's specific Nature traits
	return []

func character_nature_opposed_skills() -> Array:
	# Return an array of skill names that are opposed to the character's Nature
	# This should also be customized based on the character's specific Nature traits
	return []

func calculate_nature_bonus() -> int:
	# Calculate bonus for actions that align with the character's Nature
	return max(1, nature / 2)

func calculate_nature_penalty() -> int:
	# Calculate penalty for actions that go against the character's Nature
	return -max(1, nature / 2)




func rank_up():
	if rank < 4:  # Check for rank cap
		rank += 1
		internal_level += 1
	else:
		print("Max level reached")


# Note: Movement typically does not increase on level up
# Call this when promoting a unit
func promote():
	rank = 1


func calculate_experience_gain(enemy_level: int, is_victory: bool):
	# Simplified version; adjust based on your game's rules
	var level_difference = enemy_level - internal_level
	var exp_gain = max(1, 50 + level_difference * 5)  # Basic formula; adjust as needed
	if is_victory:
		gain_experience(exp_gain)

# Calculate stats based on the equipped weapon

# Example methods for adding or removing traits
func add_trait(new_trait: String):
	if new_trait not in traits:
		traits.append(new_trait)
		# Apply any immediate effects or stat changes associated with the new trait

func remove_trait(trait_to_remove: String):
	if trait_to_remove in traits:
		traits.erase(trait_to_remove)
		# Revert any effects or stat changes associated with the removed trait

func _init():
	calculate_derived_stats()
	  # Initial calculation
func apply_modifiers():
	pass
# This function applies modifiers and recalculates stats
	#calculate_current_stats()
	

# Other Updates (assuming they are needed to be called outside)
func update_health(current: int, max: int):
	hp = current
# Assuming you have a max health variable
# max_hp = max
func update_mana(current_mana: int):
	pass
	#mana = current_mana

func calculate_derived_stats():
	# Updating derived stats based on core stats and their modifiers
	vigor += calculate_modifier(life)
	strength += calculate_modifier(life)
	technique += calculate_modifier(mind)
	insight += calculate_modifier(mind)
	will += calculate_modifier(spirit)
	conviction += calculate_modifier(spirit)
	# You may add here any other derived stats calculations

