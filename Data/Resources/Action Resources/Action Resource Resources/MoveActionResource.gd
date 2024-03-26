# MoveActionResource.gd
extends ActionResource
class_name MoveActionResource

# Override perform_action to handle movement
func perform_action(unit: Node, target_position: Vector3):
	var movement = true
	# Implementation details will vary based on your game's architecture.
	# This function should instruct the `unit` to move to `target_position`.
	# For simplicity, we'll emit a signal that can be connected to your pathfinding system.
	unit.emit_signal("request_move", target_position, movement)

