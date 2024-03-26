extends CanvasLayer

func _on_quit_button_pressed():
	get_tree().quit()


func _on_load_game_button_pressed():
	print("Load game functionality not implemented yet.")


func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://Dialogue load test..tscn")
