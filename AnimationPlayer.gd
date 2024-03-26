# FadeControl.gd
extends AnimationPlayer

func _ready():
	# Connect to the DiaBus signals for fading in and out
	DiaBus.connect("fade_in", _on_fade_in)
	DiaBus.connect("fade_out", _on_fade_out)

func _on_fade_in():
	# Make sure to stop any currently playing animations first
	
	play("fade_in")

func _on_fade_out():
	# Make sure to stop any currently playing animations first
	
	play("fade_out")
