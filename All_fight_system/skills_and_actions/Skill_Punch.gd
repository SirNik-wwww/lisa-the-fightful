extends skill_base





func use():
	posible_targets = get_tree().get_nodes_in_group("Enemy")
	cur_target = posible_targets[0]
	cur_target.sprite.modulate = Color(8.065, 8.065, 8.065)
	cur_target.selected = true
	FightGlobus.enemy_reselected.connect(re_use)
	FightGlobus.target_confimed.connect(confim_skill)
	FightGlobus.cur_state = FightGlobus.b_st.ENEMY_TARGETING
	cur_target.self_button.grab_focus()


func re_use():
	cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)
	cur_target = FightGlobus.cur_enemy
	cur_target.sprite.modulate = Color(8.065, 8.065, 8.065)


#
#func target_reset(): # убирает подсветку цели
	##print(cur_target)
	#cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)



func perform(targets : Array[Char_Blank]):
	#print(targets)
	var trgt = targets[0]
	Anim_player.play("atk")
	await Anim_player.animation_finished
	trgt.change_hp(dmg)
	FightGlobus.before_battle_things.emit()
	if owner.is_in_group("Hero"):
		owner.act_texture.texture = null
	else:
		pass
