extends Node

var parent : skill_base

var targets : Array[Char_Blank]

var speed : int

func _perform():
	#for t in targets:
		#parent.perform(t)
	parent.perform(targets)
