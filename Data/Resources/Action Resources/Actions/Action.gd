class_name Action
extends Node

var type: String
var target: Vector3
var score: float

func _init(_type: String, _target: Vector3, _score: float):
	type = _type
	target = _target
	score = _score
