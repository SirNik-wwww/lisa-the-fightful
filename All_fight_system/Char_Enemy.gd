extends Char_Blank
class_name Char_Enemy

var selected : bool = false


@export var sprite : TextureRect


func _ready() -> void:
	FightGlobus.enemy_reselected.connect(not_me_anymore)
	FightGlobus.hero_reselected.connect(not_me_anymore)


func select_me():
	if FightGlobus.enemy_may_be_selected == true:
		FightGlobus.cur_enemy = self
		FightGlobus.enemy_reselected.emit()
		selected = true



func not_me_anymore():
	selected = false


func confim_traget():
	FightGlobus.target_confimed.emit()


func perform():
	var h = get_tree().get_nodes_in_group("Hero")
	var t = h.pick_random()
	t.hp -= 10
	print("enemy  " + str(self) + "  attaked  " + str(t))
