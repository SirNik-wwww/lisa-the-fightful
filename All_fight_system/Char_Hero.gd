extends Char_Blank
class_name Char_hero

#@export var actions : Array
@onready var act_texture: TextureRect = $TextureRect/ActTexture



@export var color_rect : ColorRect


var selected : bool = false 

#var max_multi_atk : int = 1
var atk_performed : int = 1


@export var HP_BAR : TextureProgressBar
@export var HP_TEXT : Label
@export var MANA_BAR : TextureProgressBar
@export var MANA_TEXT : Label


#func _ready() -> void:
	#act_texture.texture


func _process(_delta: float) -> void:
	if selected == true:
		color_rect.color = Color(1.0, 1.0, 1.0, 0.5)
	else:
		color_rect.color = Color(1.0, 1.0, 1.0, 0.0)

	change_label()



func select_me():
	if FightGlobus.hero_may_be_selected == true:
		get_tree().current_scene.cur_char = self
		FightGlobus.hero_reselected.emit()
		var selected_ones = get_tree().get_nodes_in_group("Char_is_selected")
		for one in selected_ones:
			one.selected = false
			one.remove_from_group("Char_is_selected")
		add_to_group("Char_is_selected")
		selected = true
		#print("cur char id   " + str(FightGlobus.cur_hero_id))

		var all = get_tree().get_nodes_in_group("Hero")
		var sell = all.find(self)
		FightGlobus.cur_hero_id = sell



func change_label():
	HP_BAR.value = cur_hp / (max_hp / 100.0)
	HP_TEXT.text = str(cur_hp)
