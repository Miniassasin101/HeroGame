extends TextureRect

func _ready():
	# Set the texture to stretch within the TextureRect
	self.stretch_mode = STRETCH_SCALE
	self.expand = true
	# Make the TextureRect fill its parent or the viewport
	fill_parent_or_screen()

func change_background():
	var background_path = "res://Background Art/Dialogue Backgrounds/" + GameState.current_background + ".png"
	var new_background_texture = load(background_path)
	
	if new_background_texture:
		self.texture = new_background_texture
		# Ready the fade-in effect
		setup_fade_in()
	else:
		print("Background texture not found: ", background_path)

func setup_fade_in(duration=1.0):
	var tween = get_tree().create_tween()
	# Tween the 'modulate' property to make the TextureRect fade in
	tween.tween_property(self, "modulate", Color(self.modulate.r, self.modulate.g, self.modulate.b, 1), duration)

func fill_parent_or_screen():
	# Set anchors to make the TextureRect fill its parent
	self.anchor_top = 0
	self.anchor_bottom = 1
	self.anchor_left = 0
	self.anchor_right = 1
	# Use size flags to ensure the node expands and fills the space
	self.size_flags_horizontal = SIZE_EXPAND_FILL
	self.size_flags_vertical = SIZE_EXPAND_FILL
