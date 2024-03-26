extends PopupMenu  # Or Node, if you attached the script to the parent node

func _ready():
	# Optional: Clear existing items if necessary
	print("Hello?")
	clear()
# Populate the menu based on the global character roster
	for character_name in UnitBus.character_roster.keys():
		print(character_name)
		var button = Button.new()
		button.text = character_name
		#var id = get_item_count() 
		 # Get the next ID based on the number of items
		#add_item(character_name, id)
		#var button = get_child(id)
		button.pressed.connect(self, "_on_menu_item_pressed")
		#UnitBus.connect("roster_updated", Callable(self, "_on_roster_updated"))

func _input(event):
	if event.is_action_pressed("Ui_Cancel"):  # Assuming "B" is mapped to "ui_cancel" in your Input Map
		if is_visible():
			hide()
		else:
			show()

func _on_menu_item_pressed(id):
	print("Pressed")
	var name = get_item_text(id)  # Get the character name based on the pressed item ID
	UnitBus.emit_signal("PCName", name)  # Emit the signal with the character name
