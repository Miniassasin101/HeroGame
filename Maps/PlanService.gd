# PlanService.gd

extends Node

signal moveparse(unit_path, enemy_number, unit_name)

@onready var movement_service = $"../Navigation Service/Pathfinding/MovementService"

func _ready():
	WorldState.connect("snapshot",  Callable(self, "initialize_with_snapshot"))
	Planning.connect("execute_plan", Callable(self, "execute_plan"))

func execute_plan(plan):
	print("ZE PLANNN")
	for item in plan:
		if item["type"] == "combo":
			var coroutines = []
			for action in item["actions"]:
				if action["type"] == "move":
					# Assuming move_execute is a function that returns a Thread when called,
					# so we can wait for its completion.
					print("He MOVE Yeeeee", action)
					print(Planning.snapshot_enemy_roster[action["unit"]].enemy_number)
					coroutines.append(await(move_execute(action["unit_path"], \
					Planning.snapshot_enemy_roster[action["unit"]].enemy_number, action["unit"])))
				elif action["type"] == "attack":
					# Similarly, assuming attack_execute initiates the action and returns a Thread.
					coroutines.append(await(attack_execute(action["unit"], action["target_position"])))

			# Wait for all coroutines in the group to complete.
			for coroutine in coroutines:
				await coroutine

		elif item["type"] == "sync":
			#TEST: Sync marker reached. Simply proceed as this indicates we should wait for all prior actions to complete
			print("Sync point reached, all prior actions completed.")
			#continue  # In this context, continue just moves to the next iteration of the loop, but sync handling could be more complex

func move_execute(unit_path, enemy_number, unit_name):
	# Start move action and emit a signal upon completion.
	# Assuming you have a mechanism or a node that handles move actions and signals completion.
	print("Signal EMitted")
	#moveparse.emit(unit_path, enemy_number, unit_name)
	await movement_service.moveparse(unit_path, enemy_number, unit_name)
	#when   # This awaits a signal named 'signal_move_completed' from the node.
	print("Move action completed for unit:", unit_name)
	#await get_tree().create_timer(0.5).timeout
	return true
	

func signal_emitter():
	emit_signal("move_completed")


func attack_execute(unit, target_position):
	# Start attack action and emit a signal upon completion.
	# Assuming a similar setup for handling attack actions.
	#var attacknode = get_node("Services/Combat Service/Ability And Attack Service")
	#attacknode.attackparse()
	#await attacknode.attack_completed  # This awaits a signal named 'signal_attack_completed' from the node.
	#print("Attack action completed for unit:", unit)
	pass
