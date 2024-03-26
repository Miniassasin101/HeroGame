extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.show_dialogue_balloon(load("res://Dialogue Files/Act 1/intro.dialogue"), "start")
	DiaBus.connect("sceneswap", growup)
	DiaBus.connect_dialogue_signal(self, "on_dialogue_requested")




func on_dialogue_requested(dialogue_file_name: String):
	var dialogue_path = "res://Dialogue Files/Act 1/" + dialogue_file_name + ".dialogue"
	DialogueManager.show_dialogue_balloon(load(dialogue_path), "start")

func growup():
	get_tree().change_scene_to_file("res://DiaTest2.tscn")
