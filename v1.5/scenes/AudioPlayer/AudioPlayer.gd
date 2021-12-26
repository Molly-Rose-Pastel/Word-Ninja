extends Node2D

func _ready():
	GameData.audio = self

func play_sound(sound):
	
	if GameData.is_sound == "x":
		match sound:
			"stroke":
				var random_number = int(rand_range(0, $strokes.get_child_count()))
				$strokes.get_children()[random_number].play(0.0)
			"die":
				$die_sound.play(0.0)
			"hit":
				$hit_sound.play(0.0)
			"explosion":
				$explosion_sound.play(0.0)
			"wrong":
				$wrong_sound.play(0.0)
			"cut":
				$cut_sound.play(0.0)
			"dark souls":
				$dark_souls_sound.play(0.0)

func toggle_music():
	if GameData.is_music == "x":
		GameData.is_music = " "
		if $song_music.playing:
			$song_music.stop()
	else:
		GameData.is_music = "x"
		if !$song_music.playing:
			$song_music.play(0.0)

func toggle_sound():
	if GameData.is_sound == "x":
		GameData.is_sound = " "
	else:
		GameData.is_sound = "x"
