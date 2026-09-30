extends skill_base


func use():
	posible_targets = get_tree().get_nodes_in_group("Enemy")
	cur_targets.assign(posible_targets)
	#cur_target = posible_targets[0]
	for t in posible_targets:
		t.sprite.modulate = Color(8.065, 8.065, 8.065)
		t.selected = true
	#cur_target.selected = true
	#FightGlobus.enemy_reselected.connect(re_use)
	FightGlobus.target_confimed.connect(confim_skill)
	FightGlobus.cur_state = FightGlobus.b_st.ENEMY_TARGETING
	#cur_target.self_button.grab_focus()
	var all_b = get_tree().get_nodes_in_group("select_all_button")
	all_b[0].grab_focus()

#
#func re_use():
	#cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)
	#cur_target = FightGlobus.cur_enemy
	#cur_target.sprite.modulate = Color(8.065, 8.065, 8.065)


#
#func target_reset(): # убирает подсветку цели
	##print(cur_target)
	#cur_target.sprite.modulate = Color(1.0, 1.0, 1.0)



func perform(targets : Array):
	Anim_player.play("atk")
	await Anim_player.animation_finished
	for t in targets:
		t.change_hp(dmg)
		await get_tree().create_timer(0.2).timeout
	FightGlobus.before_battle_things.emit()
	#print(str(self) + "  attaked  " + str(target))
	if owner.is_in_group("Hero"):
		owner.act_texture.texture = null
	else:
		pass
