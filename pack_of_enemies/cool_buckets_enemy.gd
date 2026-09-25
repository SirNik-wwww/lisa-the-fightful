extends Char_Enemy

@onready var node: Node = $Node/skill_base

func _on_button_pressed() -> void:
	if FightGlobus.enemy_may_be_selected == true:
		if selected == false:
			select_me()
		else:
			confim_traget()
			#print("Yes")
