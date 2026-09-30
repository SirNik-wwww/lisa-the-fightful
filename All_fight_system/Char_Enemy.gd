extends Char_Blank
class_name Char_Enemy

var selected : bool = false


@export var sprite : TextureRect


func _ready() -> void:
	FightGlobus.enemy_reselected.connect(not_me_anymore)
	FightGlobus.hero_reselected.connect(not_me_anymore)
	self_button.focus_entered.connect(select_me)
	self_button.focus_exited.connect(not_me_anymore)



func select_me():
	if FightGlobus.enemy_may_be_selected == true:
		FightGlobus.cur_enemy = self
		FightGlobus.enemy_reselected.emit()
		sprite.modulate = Color(8.065, 8.065, 8.065)
		selected = true



func not_me_anymore():
	selected = false
	sprite.modulate = Color(1.0, 1.0, 1.0)


func select_skill():
	var all_skills = skill_tree.get_children()
	var skill = all_skills.pick_random()
	skill.use()
	#pass

func confim_traget():
	FightGlobus.target_confimed.emit()


func perform():
	var h = get_tree().get_nodes_in_group("Hero")
	var t = h.pick_random()
	t.hp -= 10
	print("enemy  " + str(self) + "  attaked  " + str(t))


func change_label():
	sprite.modulate = Color(0.0, 0.0, 0.0, 0.0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1.0, 1.0, 1.0)
