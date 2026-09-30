extends Node

class_name skill_base

const NUMB_SKILL = preload("uid://8k33t5m4aity")


@export var skill_name : String = "Панч"

@export var target_type : String 

@export var Anim_player : AnimationPlayer

@export var icon : CompressedTexture2D

var posible_targets : Array 

var dmg : int = 100

var cur_target : Char_Blank
var cur_targets : Array[Char_Blank] # ???
#var final_targets : Array[Char_Blank]

var skill_will_be_performed : bool = false



func use():
	pass



func re_use():
	pass



func target_reset(): # убирает подсветку цели
	pass



func perform(targets : Array[Char_Blank]):
	pass



func _input(_event: InputEvent) -> void:
	if owner.selected == true and FightGlobus.cur_state == FightGlobus.b_st.ENEMY_TARGETING:
		if Input.is_action_just_pressed("ui_cancel"):
			target_reset()



func confim_skill():
	if owner.selected == true:
		var N = get_tree().get_nodes_in_group("Action_line")
		var B : Node = N[0]
		if owner.atk_performed == 0:
			for sk in B.get_children():
				if sk.parent == self:
					sk.queue_free()

		owner.atk_performed = 0
		var skill_deputy = NUMB_SKILL.instantiate()
		skill_deputy.parent = self
		if cur_target != null:
			#print(cur_target)
			skill_deputy.targets.append(cur_target)
			cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)
		if cur_targets.size() > 0:
			skill_deputy.targets.assign(cur_targets)
			for u in cur_targets:
				u.sprite.modulate = Color(1.0, 1.0, 1.0)
		skill_deputy.speed = owner.speed
		owner.act_texture.texture = icon
		B.add_child(skill_deputy)
		

		FightGlobus.cur_state = FightGlobus.b_st.HERO_CHOOSE
		await get_tree().process_frame # это чтобы исключить "гонку скриптов"
		await get_tree().process_frame # типа глобальный скипт не испевает иначе сменить стейт

		var _char = get_tree().get_nodes_in_group("Hero")
		if FightGlobus.cur_hero_id < _char.size() - 1:
			FightGlobus.cur_hero_id += 1
			FightGlobus.select_next_hero.emit()
			#print("parent: " + str(owner))
		else:
			FightGlobus.player_ends_turn.emit()
