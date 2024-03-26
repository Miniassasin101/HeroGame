#UiOverlay.gd
extends MenuBar

@onready var character_menu = $CharacterMenu

@onready var character_sheet_panel = $CharacterSheetPanel
@onready var name_label = %NameLabel
@onready var level_label = %LevelLabel
@onready var class_label = $CharacterSheetPanel/VBoxContainer/ClassLabel
@onready var mana_label = $CharacterSheetPanel/VBoxContainer/ManaLabel
@onready var str_label = $CharacterSheetPanel/VBoxContainer/StrLabel
@onready var mag_label = $CharacterSheetPanel/VBoxContainer/MagLabel
@onready var skill_label = $CharacterSheetPanel/VBoxContainer/SkillLabel
@onready var dex_label = $CharacterSheetPanel/VBoxContainer/DexLabel
@onready var spd_label = $CharacterSheetPanel/VBoxContainer/SpdLabel
@onready var def_label = $CharacterSheetPanel/VBoxContainer/DefLabel
@onready var res_label = $CharacterSheetPanel/VBoxContainer/ResLabel
@onready var lck_label = $CharacterSheetPanel/VBoxContainer/LckLabel
@onready var rating_label = $CharacterSheetPanel/VBoxContainer/RatingLabel
@onready var ph_atk_label = $CharacterSheetPanel/VBoxContainer/Ph_AtkLabel
@onready var mag_atk_label = $CharacterSheetPanel/VBoxContainer/Mag_AtkLabel
@onready var hit_label = $CharacterSheetPanel/VBoxContainer/HitLabel
@onready var avo_label = $CharacterSheetPanel/VBoxContainer/AvoLabel
@onready var crit_label = $CharacterSheetPanel/VBoxContainer/CritLabel
@onready var ddg_label = $CharacterSheetPanel/VBoxContainer/DdgLabel
@onready var rng_label = $CharacterSheetPanel/VBoxContainer/RngLabel
@onready var hp_label = $CharacterSheetPanel/VBoxContainer/HPLabel
@onready var mov_label = $CharacterSheetPanel/VBoxContainer/MovLabel
@onready var mt_label = $CharacterSheetPanel/VBoxContainer/MtLabel
@onready var crit_chance_label = $CharacterSheetPanel/VBoxContainer/CritChanceLabel
@onready var hit_chance_label = $CharacterSheetPanel/VBoxContainer/HitChanceLabel
@onready var add_character_line_edit = %AddCharacterLineEdit
@onready var remove_character_button = %RemoveCharacterButton
@onready var remove_character_line_edit = %RemoveCharacterLineEdit
@onready var add_character_button = %AddCharacterButton
var stat_labels = {}
@onready var experience_input = $RosterEditor/VBoxContainer/ExperienceInput.text
@onready var add_exp_button = $RosterEditor/VBoxContainer/AddExpButton
@onready var selected_character_name = ""


#undo marker
func _ready():
	#Connect signals
	UnitBus.connect("character_experience_updated", Callable(self, "_update_character_sheet_ui"))
	UnitBus.connect("roster_updated", Callable(self, "_on_roster_updated"))
	_on_roster_updated()  # Initial population
func _update_character_sheet_ui(character_name: String):
	if character_name == selected_character_name:
		update_character_sheet(character_name)  # Assume this method exists to refresh the UI based on the character's current stats



func _on_add_exp_button_pressed():
	print(experience_input)
	experience_input = $RosterEditor/VBoxContainer/ExperienceInput.text
	var exp_points = int(experience_input)
	print(exp_points)
	print(selected_character_name)
	if exp_points > 0 and selected_character_name in UnitBus.character_roster:
		print("yeehaw")
		UnitBus.character_roster[selected_character_name].gain_experience(exp_points)
		
		  # Clear the input field
		$RosterEditor/VBoxContainer/ExperienceInput.text = ""  # Clear the input field
		_update_character_sheet_ui(selected_character_name)


func update_character_sheet(character_name):
	var character = UnitBus.get_character_stats(character_name)
	character.update_derived_stats()  # Ensure the stats are updated
	name_label.text = "Name: " + str(character.name)
	level_label.text = "Level: " + str(character.level)
	class_label.text = "Class: " + str(character.current_class)
	mana_label.text = "Mana: " + str(character.mana)
	str_label.text = "Str: " + str(character.strength)
	mag_label.text = "Mag: " + str(character.magic)
	dex_label.text = "Dex: " + str(character.dexterity)
	spd_label.text = "Spd: " + str(character.speed)
	def_label.text = "Def: " + str(character.defence)
	res_label.text = "Res: " + str(character.resistance)
	lck_label.text = "Lck: " + str(character.luck)
	skill_label.text = "Skill: " + str(character.skill)
	rating_label.text = "Rating: " + str(character.rating)
	ph_atk_label.text = "Int Mp: " + str(character.physical_attack)
	mag_atk_label.text = "Ext Mp: " + str(character.magic_attack)
	hit_label.text = "Hit: " + str(character.hit)
	avo_label.text = "Avo: " + str(character.avoidance)
	crit_label.text = "Crit: " + str(character.critical)
	ddg_label.text = "Ddg: " + str(character.dodge)
	rng_label.text = "Rng: " + str(character.range)
	hp_label.text = "HP: " + str(character.hp)
	mov_label.text = "Mov: " + str(character.movement)
	mt_label.text = "Mt: " + str(character.might)
	crit_chance_label.text = "CChance: " + str(character.critical_chance)
	hit_chance_label.text = "HChance: " + str(character.hit_chance)
	# Update basic stats


	# Update derived stats
	var derived_stats = character.calculate_current_stats()
	# ... Update the derived stat labels using the derived_stats dictionary



func _on_roster_updated():
	print("Roster function activated")
	character_menu.clear()  # Clear existing items
	for character_name in UnitBus.character_roster.keys():
		character_menu.add_item(character_name)

func _on_menu_item_selected(index):
	print("show menu item selected function activated")
	var character_name = character_menu.get_item_text(index)
	selected_character_name = character_name
	update_character_sheet(character_name)
	_show_character_sheet(character_name)

func _show_character_sheet(character_name):
	print("show character Sheet function activated")
	# Update other labels and lists...
	character_sheet_panel.show()
	update_character_sheet(character_name)

func _on_add_character_button_pressed():
	var character_name = add_character_line_edit.text
	if character_name != "":
		UnitBus.add_character_by_name(character_name)
		add_character_line_edit.text = ""

func _on_remove_character_button_pressed():
	var character_name = remove_character_line_edit.text
	if character_name in UnitBus.character_roster:
		UnitBus.remove_character(character_name)
		remove_character_line_edit.text = ""  # Clear the line edit after removing
	else:
		print("Character not found in roster")

func _on_character_menu_index_pressed(index):
	print("menu press function activated")
	var character_name = character_menu.get_item_text(index)
	selected_character_name = character_name
	update_character_sheet(character_name)
	_show_character_sheet(character_name)







