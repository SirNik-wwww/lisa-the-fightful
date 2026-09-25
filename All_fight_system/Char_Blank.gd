extends Control
class_name Char_Blank

@export var self_button : Button # кнопка для выбора героя или противника

var is_dead : bool = false

@export var speed : int
@export var dmg : int
@export var max_hp : int
@export var def : int
var cur_hp : int

@export var max_sp : int
@export var max_tp : int
@export var max_bullshit : int
var cur_sp : int
var cur_tp : int
var cur_bullshit : int

@export var ANIM_PL : AnimationPlayer




func _ready() -> void:
	#await get_tree().create_timer(1.2).timeout
	cur_hp = max_hp
	change_hp(0, false)


func change_hp(how_much : int = 1, is_dmg : bool = true):
	if is_dead == false:
		if is_dmg == true:
			how_much = how_much - def
			cur_hp = clamp(cur_hp - how_much, -99, max_hp)
		else :
			cur_hp = clamp(cur_hp + how_much, -99, max_hp)
		change_label()

func change_label():
	pass

func resurrect():
	is_dead = false
