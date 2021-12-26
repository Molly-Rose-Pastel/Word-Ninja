extends Node2D

export var word_intervall_s = 4
export var word_speed = 2
export var word_amount = 10
export var WordEnemy : PackedScene

var character_total = 0
var start_time_total = 0
var start_time_character = 0
var word_locked = false
var current_word = null
var game_started = false

var word_enemy_index = 1
var word_enemy_list = []

func _ready():
	GameData.level = self

func _process(_delta):
	
	match GameData.game_state:
		"game":
			update_hud()
			if $word_enemies.get_child_count() == 0:
				game_started = false
				GameData.saveData()
				GameData.game_state = "menu"
				GameData.menu.show()
		"menu":
			GameData.menu.show()
			GameData.menu.update_menu()
		"dead":
			return
		"statistics":
			return


func _input(event):
	if event is InputEventKey and event.is_pressed():
		
		var event_string = char(event.unicode)
		
		if event_string == "":
			return
		
		match GameData.game_state:
			"menu":
				match event_string:
					"p":
						GameData.menu.hide()
						start()
					"t":
						GameData.statistics.update_data()
						GameData.statistics.show()
						GameData.game_state = "statistics"
					"m":
						GameData.audio.toggle_music()
					"s":
						GameData.audio.toggle_sound()
					"j":
						word_speed -= 0.25
						if word_speed < 1:
							word_speed = 1
						word_intervall_s = 8 / word_speed
					"k":
						word_speed += 0.25
						if word_speed > 4:
							word_speed = 4
						word_intervall_s = 8 / word_speed
				

				GameData.audio.play_sound("stroke")
			
			"game":
				if !word_locked:
					if GameData.Enemies.has(event_string):
						if GameData.Enemies[event_string].get_node("VisibilityNotifier2D").is_on_screen():
							word_locked = true
							current_word = GameData.Enemies[event_string]
							current_word.type_first_letter(event_string)
							start_time_character = OS.get_ticks_msec()
							if !game_started:
								game_started = true
								start_time_total = OS.get_ticks_msec()
				else:
					if current_word.type_first_letter(event_string):
						var tick = OS.get_ticks_msec()
						var letter_time =  tick - start_time_character
						if GameData.letter_time[event_string] > 0:
							GameData.letter_time[event_string] = int((GameData.letter_time[event_string] + letter_time) / 2)
						else:
							GameData.letter_time[event_string] = letter_time
						start_time_character = tick
			"dead":
				return
			"statistics":
				return

func update_hud():
	if game_started:
		$hud.show()
		$hud/enemy_value.bbcode_text = "[center]"+str(GameData.Enemies.size())
		var elapsed = (OS.get_ticks_msec() - start_time_total) / 1000.0
		var cpm = stepify((character_total / elapsed)*60, 0.01)
		$hud/cpm_value.bbcode_text = "[center]"+str(cpm)
	else:
		$hud.hide()


func start():
	
	GameData.game_state = "game"
	character_total = 0
	start_time_total = 0
	word_enemy_index = 1
	
	$Ninja.reset()
	
	word_enemy_list.clear()
	
	for _x in range(word_amount):
		var unit = WordEnemy.instance()
		$word_enemies.add_child(unit)
		unit.speed = word_speed
		word_enemy_list.push_back(unit)
	
	GameData.words = $tools/WordGenerator.generate_weighted_wordset(word_amount)
	
	var index = 0
	for word in GameData.words:
		var letter = word[0]
		GameData.Enemies[letter] = $word_enemies.get_children()[index]
		GameData.Enemies[letter].set_word(word)
		index += 1
	
	$tools/Timer.start(word_intervall_s)
	word_enemy_list[0].is_ready = true
	game_started = true

func stop():
	GameData.game_state = "dead"
	$tools/Timer.stop()
	for unit in word_enemy_list:
		var wr = weakref(unit)
		if wr.get_ref():
			unit.is_ready = false
			unit.call_deferred("queue_free")
	GameData.saveData()
	GameData.dead.start()


func _on_Timer_timeout():
	word_enemy_list[word_enemy_index].is_ready = true
	word_enemy_index += 1
	if word_enemy_index == word_enemy_list.size():
		GameData.saveData()
		$tools/Timer.stop()
		word_enemy_index = 1
