extends Node
class_name Skill_menu

@export var skill_name : String = "Скилл"

@export var another_skills : Node

func use():
	FightGlobus.cur_state = FightGlobus.b_st.SKILL_CHOOSE
	get_tree().current_scene.show_dop_menu(false, another_skills)
