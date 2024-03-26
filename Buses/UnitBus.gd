# UnitBus.gd
#This script is an Autoloaded Singleton
extends Node


# Dictionary to hold the character roster
# Keys are character names, and values are instances of UnitStatsResource
var character_roster = {}
var weapon_inventory = {}  # Tracks all instanced weapons
var item_inventory = {}  # Tracks all instanced items
# Define signals
signal unit_updated(unit_resource)
signal roster_updated()
signal character_experience_updated(character_name)
signal PCName(name)

func _ready():
	initialize_characters()
	notify_listeners()
func initialize_characters():
	# Example characters - replace with dynamic loading if necessary
	add_character_by_name("Sol")
	add_character_by_name("Nox")
	add_character_by_name("Luna")

	emit_signal("roster_updated")
func notify_listeners():
	for character_name in character_roster.keys():
		var character_resource = character_roster[character_name]
		character_resource.connect("experience_gained", Callable(self, "_on_character_experience_gained").bind(character_name))
	emit_signal("roster_updated")

func add_combatant(name: String):
	emit_signal("PCName", name)

func _on_character_experience_gained(character_name: String):
	emit_signal("character_experience_updated", character_name)  # Notify UI to update

# Function to add a character to the roster
func add_character_by_name(name: String):
	var path = "res://Data/Resources/Unit Resources/Units/Player Units/" + name + ".tres"
	var character_resource: UnitStatsResource = load(path)
	if character_resource:
		character_roster[name] = character_resource
		character_resource.connect("experience_gained", Callable(self, "_on_character_experience_gained").bind(name))

		emit_signal("character_updated", name)
		emit_signal("roster_updated")
	else:
		push_error("Failed to load character: %s" % path)

func add_character(name: String, stats: UnitStatsResource):
	character_roster[name] = stats
	# Optionally, emit a signal every time a new character is added
	emit_signal("roster_updated")

# Function to remove a character from the roster
func remove_character(name: String):
	character_roster.erase(name)
	emit_signal("character_updated", name)
	emit_signal("roster_updated")

# Function to get a character's stats by name
func get_character_stats(name: String) -> UnitStatsResource:
	return character_roster.get(name)
# Signal handler for when a character gains experience

# Function to update the UI overlay
func update_ui_overlay():
	# Assuming you have a reference to the UI overlay scene instance
	# This might look different based on how you've set up your UI
	var ui_overlay = get_node_or_null("res://Menus/Character Menu/UIOverlay.tscn") # Adjust the path as necessary
	if ui_overlay:
		ui_overlay.populate_character_list(character_roster)
		

# Function to emit unit update signals
func update_unit(unit_resource: UnitStatsResource):
	emit_signal("unit_updated", unit_resource)


# Functions for weapons and items handling

func add_weapon_to_inventory(name: String):
	var path = "res://Data/Resources/Weapon Resources/Weapons/" + name + ".tres"
	var weapon_resource: WeaponStatsResource = load(path)
	if weapon_resource:
		weapon_inventory[weapon_resource.name] = weapon_resource
	
func add_item_to_inventory(item_resource: Resource):
	item_inventory[item_resource.name] = item_resource

func equip_weapon_to_unit(unit_name: String, weapon_name: String):
	if weapon_name in weapon_inventory and unit_name in character_roster:
		var unit_resource = character_roster[unit_name]
		unit_resource.equipped_weapon = weapon_inventory[weapon_name]
		unit_resource.calculate_current_stats()
		emit_signal("unit_updated", unit_resource)

func unequip_weapon_from_unit(unit_name: String):
	if unit_name in character_roster:
		var unit_resource = character_roster[unit_name]
		unit_resource.equipped_weapon = null
		unit_resource.calculate_current_stats()
		emit_signal("unit_updated", unit_resource)
