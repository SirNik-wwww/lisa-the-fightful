extends Char_hero

#@onready var color_rect: ColorRect = $TextureRect/ColorRect



func _on_button_pressed() -> void:
	if selected == false:
		select_me()
	else:
		var bttns = get_tree().get_nodes_in_group("skill_button")
		bttns[0].grab_focus()




func _on_button_focus_entered() -> void:
	select_me()
