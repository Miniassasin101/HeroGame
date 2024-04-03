# StatBlockResource.gd
extends Resource
class_name StatBlockResource

# Essential properties for AI-controlled units
@export var name: String
@export var rank: int = 1
@export var internal_level: int = 1

# Base Core Stats
@export var life: int = 2
@export var mind: int = 2
@export var spirit: int = 2
@export var nature: int = 2

# Derived Stats
@export var vigor: int = 12  # Life-based, example starting value
@export var strength: int = 12  # Life-based
@export var technique: int = 12  # Mind-based
@export var insight: int = 12  # Mind-based
@export var will: int = 12  # Spirit-based
@export var conviction: int = 12  # Spirit-based

# Base Stats
@export var hp: int = 15
@export var current_hp: int = hp
@export var ap: int = 3
@export var movement: int = 3

func _init():
	calculate_derived_stats()

func calculate_modifier(stat_value: int) -> int:
	return floor((stat_value - 10) / 2.0)



func calculate_derived_stats():
	# Updating derived stats based on core stats and their modifiers
	vigor += calculate_modifier(life)
	strength += calculate_modifier(life)
	technique += calculate_modifier(mind)
	insight += calculate_modifier(mind)
	will += calculate_modifier(spirit)
	conviction += calculate_modifier(spirit)
	# You may add here any other derived stats calculations

func reset_ap():
	# This function might not be necessary for AI units if they don't use AP in the same way,
	# but you can include logic here if there are any end-of-turn adjustments needed for AI units.
	pass