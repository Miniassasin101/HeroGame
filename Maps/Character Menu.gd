extends Node

var menu: PopupMenu

func _ready():
	# Assume the PopupMenu is a child of this node, adjust the path as necessary
	menu = $PopupMenu
	menu.connect("id_pressed", Callable(self, "_on_menu_item_pressed"))
	populate_menu()
	# Make sure the menu is hidden initially
	#menu.hide()

func _input(event):
	if event.is_action_pressed("Ui_Cancel"):
		toggle_menu_visibility()

func populate_menu():
	menu.clear()  # Clear existing items
	var id = 0
	for character_name in UnitBus.character_roster.keys():
		menu.add_item(character_name, id)
		id += 1

func toggle_menu_visibility():
	if menu.is_visible():
		menu.hide()
	else:
		menu.show()

func _on_menu_item_pressed(id):
	var name = menu.get_item_text(id)
	UnitBus.emit_signal("PCName", name)

