extends Node
# AbilityElement.gd
class_name AbilityElement

var unit_id
var ability_name
var payload

func _init(_unit_id, _ability_name, _payload):
	unit_id = _unit_id
	ability_name = _ability_name
	payload = _payload
