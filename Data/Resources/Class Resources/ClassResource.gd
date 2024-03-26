# ClassResource.gd
extends Resource
class_name ClassResource

# Enum for Movement Types
enum MovementType {
	INFANTRY,
	CAVALRY,
	FLYING,
	ARMORED
}

# Basic class information
@export var _class_name : String
@export var movement_type : MovementType
@export var base_MOV : int = 5

# Growth rate bonuses added to base growth rates of characters
@export var growth_rate_bonus : Dictionary = {
	"HP": 0.0, 
	"Attack": 0.0, 
	"Defense": 0.0, 
	"Speed": 0.0, 
	"Magic": 0.0,
	"Skill": 0.0, 
	"Resistance": 0.0,
	"Luck": 0.0
}

# Bonus stats added to base stats of characters
@export var bonus_stats : Dictionary = {
	"HP": 0, 
	"Attack": 0, 
	"Defense": 0, 
	"Speed": 0, 
	"Skill": 0, 
	"Resistance": 0,
	"Luck": 0
}

# Helper function to apply growth rate bonuses
func apply_growth_rate_bonus(base_growth_rates: Dictionary) -> Dictionary:
	var result = base_growth_rates.duplicate()
	for stat in growth_rate_bonus.keys():
		if result.has(stat):
			result[stat] += growth_rate_bonus[stat]
	return result

# Helper function to apply bonus stats
func apply_bonus_stats(base_stats: Dictionary) -> Dictionary:
	var result = base_stats.duplicate()
	for stat in bonus_stats.keys():
		if result.has(stat):
			result[stat] += bonus_stats[stat]
	return result
