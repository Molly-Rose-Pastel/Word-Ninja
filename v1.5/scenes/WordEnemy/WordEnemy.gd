extends Node2D

var is_ready = false
var was_visible = false
var speed = 2
var current_word = ""
var first_letter = ""
var sprite_path

var stroke_index = 0

func _physics_process(_delta):
	if is_ready:
		position.x = position.x - speed

func _ready():
	initialize()
	$ExplodingSprite.initialize()


func start():
	is_ready = true

func initialize():
	randomize()
	var random_number = rand_range(0, $sprites.get_child_count())
	$sprites.get_children()[random_number].show()
	sprite_path = $sprites.get_children()[random_number]
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color("9b787887")
	style.border_color = Color("f0f0ff")
	style.border_width_bottom = 4
	style.border_width_left = 4
	style.border_width_right = 4
	style.border_width_top = 4
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	$label.set("custom_styles/normal", style)

func set_word(word):
	$label.bbcode_text = "[center]" + word
	current_word = word
	first_letter = current_word[0]


func type_first_letter(letter):
	
	var retval = false
	
	if current_word.length() > 0:
	
		if letter == current_word[0]:
			current_word = current_word.substr(1, current_word.length())
			$label.bbcode_text = "[center]" + current_word
			retval = true
			$label.get("custom_styles/normal").border_color = Color("78ff78")
			GameData.level.character_total += 1
			GameData.audio.play_sound("stroke")
		
		else:
			GameData.audio.play_sound("wrong")
		
		if current_word.length() == 0:
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
			GameData.ninja.attack(self)
	
	return retval

func play_keystroke():
	if GameData.level.is_sound == "x":
		$strokes.get_children()[stroke_index].play()
		stroke_index += 1
		if stroke_index >= $strokes.get_child_count():
			stroke_index = 0


func destroy():
	$ExplodingSprite.blowUp()
	GameData.Enemies.erase(first_letter)
	GameData.level.current_word = null
	GameData.level.word_locked = false
	is_ready = false
	GameData.audio.play_sound("cut")

func blowup():
	$sprites.hide()
	$ExplodingSprite.hide()
	$label.hide()
	$explosion.show()
	$explosion.play()
	GameData.Enemies.erase(first_letter)
	if GameData.level.current_word == self:
		GameData.level.current_word = null
		GameData.level.word_locked = false
	is_ready = false
	GameData.audio.play_sound("explosion")


func _on_VisibilityNotifier2D_screen_entered():
	was_visible = true

func _on_VisibilityNotifier2D_screen_exited():
	if was_visible and is_ready:
		is_ready = false
		GameData.Enemies.erase(first_letter)
		if GameData.level.current_word == self:
			GameData.level.current_word = null
			GameData.level.word_locked = false
		call_deferred("queue_free")


func _on_explosion_animation_finished():
	call_deferred("queue_free")
