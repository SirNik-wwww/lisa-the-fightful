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

var skill_will_be_performed : bool = false



func use():
	posible_targets = get_tree().get_nodes_in_group(target_type)
	cur_target = posible_targets[0]
	cur_target.sprite.modulate = Color(8.065, 8.065, 8.065)
	cur_target.selected = true
	FightGlobus.enemy_reselected.connect(re_aim)
	FightGlobus.target_confimed.connect(confim_skill)
	FightGlobus.cur_state = FightGlobus.b_st.ENEMY_TARGETING



func color_reset(): # убирает подсветку цели
	cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)



func re_aim():
	cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)
	cur_target = FightGlobus.cur_enemy
	cur_target.sprite.modulate = Color(8.065, 8.065, 8.065)



func perform(target : Char_Blank):
	target.change_hp(dmg)
	Anim_player.play("atk")
	await Anim_player.animation_finished
	FightGlobus.before_battle_things.emit()
	print(str(self) + "  attaked  " + str(target))
	if owner.is_in_group("Hero"):
		owner.act_texture.texture = null
	else:
		pass


func _input(_event: InputEvent) -> void:
	if owner.selected == true and FightGlobus.cur_state == FightGlobus.b_st.ENEMY_TARGETING:
		if Input.is_action_just_pressed("ui_cancel"):
			color_reset()
			#cur_target = null



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
		skill_deputy.targets = cur_target
		skill_deputy.speed = owner.speed
		owner.act_texture.texture = icon
		B.add_child(skill_deputy)
		cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)

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
