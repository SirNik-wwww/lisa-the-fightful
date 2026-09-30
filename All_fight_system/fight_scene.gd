extends Node2D

@onready var ANIM_PL: AnimationPlayer = $AnimationPlayer

#@export var enemies_node : CharPack
@export var hero_node : HBoxContainer
@export var unit_node : CharPack

var all_enemies : Array
#var all_heroes : Array
var all_units : Array
var all_speed : Dictionary

var cur_char : Char_hero

@onready var skill_container: VBoxContainer = $Skill_menu/Skill_Container

@onready var actions_line: Node = $Actions_line

@onready var b_fight: Button = $Start_menu/ButtonFight
@onready var b_flee: Button = $Start_menu/ButtonFlee



func _ready() -> void:
	await get_tree().create_timer(0.2).timeout

	FightGlobus.enemy_died.connect(en_check)
	FightGlobus.hero_reselected.connect(skill_choose)
	#FightGlobus.hero_reselected.connect(character_selection)
	FightGlobus.select_next_hero.connect(character_selection)
	FightGlobus.player_ends_turn.connect(show_end_turn_buttons)

	FightGlobus.before_battle_things.emit()
	round_start()



# Сортирует всех противников и героев в порядке скорости
func round_start():
	var units = get_tree().get_nodes_in_group("Char") #Получаем все ноды в группе персонажей
	units.sort_custom(sort_units) # Сортируем аррей по алгоритму
	#print(units)
	var _hero = hero_node.get_children(false)
	for c in _hero:
		c.atk_performed = 1
	FightGlobus.cur_hero = _hero[0]
	FightGlobus.cur_hero_id = 0

	b_fight.grab_focus()

static func sort_units(a : Char_Blank, b : Char_Blank) -> bool:
	return a.speed > b.speed # Сам алгоритм



# выбор персонажа
func character_selection():
	show_dop_menu()
	var ac : Array = get_tree().get_nodes_in_group("Hero")

	cur_char = ac[FightGlobus.cur_hero_id]
	cur_char.select_me()
	skill_choose()

	#var bttns = get_tree().get_nodes_in_group("skill_button")
	#bttns[0].grab_focus()
	cur_char.self_button.grab_focus()



# выбор скилла
func skill_choose():
	var all_children = skill_container.get_children()
	for ch in all_children:
		skill_container.remove_child(ch)
	var all_skills = cur_char.skill_tree.get_children() # получаем все скиллы персонажа
	for act in all_skills:
		var new_button = Button.new()
		new_button.text = act.skill_name
		new_button.pressed.connect(act.use)
		new_button.add_to_group("skill_button")
		skill_container.add_child(new_button)

	var end_turn_button = Button.new()
	end_turn_button.text = " "
	end_turn_button.modulate = Color(0.0, 0.0, 0.0, 0.0)
	end_turn_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	end_turn_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	end_turn_button.pressed.connect(show_end_turn_buttons)
	skill_container.add_child(end_turn_button)




# проверка сколько противников осталось и нужно ли закончить бой
func en_check():
	all_enemies = get_tree().get_nodes_in_group("Enemy")
	if all_enemies.size() <= 0:
		pass



func _on_button_fight_pressed() -> void:
	ANIM_PL.play("swipe") # проигрывание анимации перелистывания
	FightGlobus.cur_hero_id = 0 # установка первого героя - текущим
	await ANIM_PL.animation_finished

	FightGlobus.cur_state = FightGlobus.b_st.HERO_CHOOSE # переход в фазу выбора героя
	await get_tree().create_timer(0.1).timeout # небольшая задержка, что скрипты успели сработать

	character_selection() # выбор текущего героя, д
	#FightGlobus.cur_hero.self_button.grab_focus() # захват кнопки текущего героя



func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("ui_cancel"):
		if FightGlobus.cur_state == FightGlobus.b_st.ENEMY_TARGETING or FightGlobus.b_st.HERO_TARGETING or FightGlobus.b_st.ALL_TARGETING:
			FightGlobus.cur_state = FightGlobus.b_st.HERO_CHOOSE
			var en = get_tree().get_nodes_in_group("Enemy")
			for e in en:
				e.selected = false
			cur_char.self_button.grab_focus()

		if FightGlobus.cur_state == FightGlobus.b_st.HERO_CHOOSE:
			FightGlobus.cur_hero_id -= 1
			if FightGlobus.cur_hero_id >= 0:
				character_selection()
				await get_tree().create_timer(0.02).timeout
				cur_char.self_button.grab_focus()
			if FightGlobus.cur_hero_id < 0:
				ANIM_PL.play("swipe", -1, -1.0, true)
				await ANIM_PL.animation_finished
				FightGlobus.cur_state = FightGlobus.b_st.FIGHT_OR_FLEE
				b_fight.grab_focus()

	#if _event.is_action_pressed("ui_up"):
		#if  FightGlobus.cur_state == FightGlobus.b_st.FIGHT_OR_FLEE:
			#b_fight.DrawMode.DRAW_HOVER_PRESSED



func show_end_turn_buttons():
	show_dop_menu()
	cur_char.selected = false
	var all_children = skill_container.get_children()
	for ch in all_children:
		skill_container.remove_child(ch)
	var new_button = Button.new()
	new_button.text = "Зак ход"
	new_button.pressed.connect(move_line)
	skill_container.add_child(new_button)
	new_button.grab_focus()



func enemy_actions():
	var enis = get_tree().get_nodes_in_group("Enemy")
	for e in enis:
		e.select_skill()



func move_line():
	enemy_actions()
	var skills = actions_line.get_children() #Получаем все ноды в группе персонажей
	skills.sort_custom(sort_units)

	for act in skills:
		act._perform()
		#await act.parent.Anim_player.animation_finished
		await get_tree().create_timer(0.35).timeout
		act.queue_free()

	ANIM_PL.play("swipe", -1, -1.0, true)
	await ANIM_PL.animation_finished
	FightGlobus.cur_state = FightGlobus.b_st.FIGHT_OR_FLEE
	round_start()



func show_dop_menu(hero_viseble_mode : bool = true, things_source : Node = null):
	$Hero_menu/HeroContainer.visible = hero_viseble_mode

	if hero_viseble_mode == false and things_source != null:
		var items = things_source.get_children()
		var item_id = 3
		var cur_holder : HBoxContainer

		var first_holder : HBoxContainer
		var is_first : bool = true

		for i in items:
			var new_button = Button.new()
			new_button.text = str(i.skill_name)
			new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			new_button.pressed.connect(i.use)
			if item_id >= 2:
				var new_holder := HBoxContainer.new()
				$Hero_menu/ItemContainer.add_child(new_holder)
				cur_holder = new_holder
				if is_first == true:
					first_holder = cur_holder
					is_first = false
				item_id = 0
			item_id += 1
			cur_holder.add_child(new_button)
		first_holder.get_child(0).grab_focus()
		is_first = true

		if cur_holder.get_children().size() == 1:
			var dumb_child = Control.new()
			dumb_child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cur_holder.add_child(dumb_child)


	else :
		var items = $Hero_menu/ItemContainer.get_children()
		for i in items:
			i.queue_free()





func _on_select_all_button_pressed() -> void: #нужна для того, чтобы выбирать всех героев/врагов
	FightGlobus.target_confimed.emit()
