extends Node

# Это глобальный скрипт для боевой системы.
# Нужно добавить его в глабальные скрипты в настройках проекта.
# Проект -> Настройки проекта -> Глобальные -> Выбрать скипт/сцену

enum b_st {FIGHT_OR_FLEE, HERO_CHOOSE, ENEMY_TARGETING, HERO_TARGETING, ALL_TARGETING, SKILL_CHOOSE} #possible battle_statements
# FIGHT_OR_FLEE - начало боя с 2 кнопками
# HERO_CHOOSE - выбор героя
# N_TARGETING - прицеливание в гороев/противников/всех
# SKILL_CHOOSE - выбор скилла из меню скиллов
var cur_state : b_st = b_st.FIGHT_OR_FLEE


@warning_ignore("unused_signal")
signal enemy_died # для подсчёта оставшихся противников в комнате
@warning_ignore("unused_signal")
signal before_battle_things
@warning_ignore("unused_signal")
signal hero_reselected # должен имитится после того как выбран другой герой
@warning_ignore("unused_signal")
signal enemy_reselected
@warning_ignore("unused_signal")
signal target_deselected
@warning_ignore("unused_signal")
signal target_confimed
@warning_ignore("unused_signal")
signal select_next_hero
@warning_ignore("unused_signal")
signal player_ends_turn



var hero_may_be_selected : bool = false
var enemy_may_be_selected : bool = false

var cur_enemy : Char_Enemy

var cur_hero : Char_hero
var cur_hero_id : int = 0
#
#func _ready() -> void:
	#target_deselected



func _process(_delta: float) -> void:
	match cur_state:
		b_st.FIGHT_OR_FLEE:
			hero_may_be_selected = false
			enemy_may_be_selected = false
			#print("FIGHT_OR_FLEE")

		b_st.HERO_CHOOSE:
			hero_may_be_selected = true
			enemy_may_be_selected = false
			#print("HERO_CHOOSE")

		b_st.ENEMY_TARGETING:
			hero_may_be_selected = false
			enemy_may_be_selected = true
			#print("ENEMY_TARGETING")

		b_st.ALL_TARGETING:
			hero_may_be_selected = true
			enemy_may_be_selected = true
