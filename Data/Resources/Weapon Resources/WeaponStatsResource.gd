extends Resource
class_name WeaponStatsResource

# Basic weapon properties
@export var name: String
@export var damage_dice: String = "1d6" # Example: "1d8"
@export var damage_type: String = "B" # B for Bludgeoning, P for Piercing, S for Slashing
@export var range: int = 1 # Range in feet for ranged weapons, 0 for melee
@export var reload_actions: int = 0 # Number of actions to reload, 0 if not applicable
@export var hands_required: String = "1" # "1" for one-handed, "2" for two-handed, "1+" for special cases like longbows
@export var weapon_group: String # Group name, affects critical specialization benefits
@export var weapon_traits: Array[String] = [] # List of traits, like ["Finesse", "Disarm"]
@export var ammunition_type: String = "" # If applicable, type of ammunition used

# Derived and additional properties not directly tied to the basic Pathfinder rules
# These could be related to game-specific mechanics or enhancements
@export var magical_properties: Dictionary = {} # Key-value pairs for magical effects, if any

# This method updates the damage dice based on effects that increase weapon damage dice size
func increase_damage_dice():
	var dice_sizes = ["1d4", "1d6", "1d8", "1d10", "1d12"]
	var current_index = dice_sizes.find(damage_dice)
	if current_index != -1 and current_index < dice_sizes.size() - 1:
		damage_dice = dice_sizes[current_index + 1]

# Utility function to handle the logic for weapon traits, if needed
func has_trait(trt) -> bool:
	return trt in weapon_traits

# Example utility functions based on weapon traits or groups could be added here
# For example, checking for specific traits affecting gameplay mechanics

func _init():
	# Initial setup or calculations can be done here, if necessary
	pass

# Additional methods to interact with or modify weapon stats could be implemented,
# such as applying runes, enchantments, or custom game-specific effects
