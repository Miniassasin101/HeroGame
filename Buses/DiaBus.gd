# DialogueBus.gd
extends Node


# Define signals here
# Example: signal function_name(argument, other_arguments)
signal sceneswap

signal fade_in

signal fade_out

signal dialogue_requested(dialogue_file_name)


#Dialogue
func emit_dialogue_signal(dialogue_file_name: String):
	emit_signal("dialogue_requested", dialogue_file_name)

func connect_dialogue_signal(target: Object, method_name: String):
	var method_callable = Callable(target, method_name)
	connect("dialogue_requested", method_callable)

#screenfade
func emit_fade_screen_signal(duration: float):
	emit_signal("fade_screen", duration)
