class_name Note
extends Node

var is_held : bool
var start : float
var end : float

func make_held_note(attack, end):
	is_held = true
	self.attack = attack
	self.end = end
	
func make_regular(attack):
	is_held = false
	self.attack = attack
	
func get_is_held():
	return is_held
