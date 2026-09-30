extends skill_base



func use():
	var skill_deputy = NUMB_SKILL.instantiate()
	var fdfd = get_tree().get_nodes_in_group("Hero").pick_random()
	skill_deputy.targets.append(fdfd)
	skill_deputy.speed = owner.speed
	skill_deputy.parent = self

	var N = get_tree().get_nodes_in_group("Action_line")
	var B : Node = N[0]
	B.add_child(skill_deputy)



func perform(targets : Array[Char_Blank]):
	var trgt = targets[0]
	Anim_player.play("atk")
	await Anim_player.animation_finished
	trgt.change_hp(dmg)
