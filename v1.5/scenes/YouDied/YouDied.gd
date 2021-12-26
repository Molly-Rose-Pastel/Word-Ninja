extends Node2D

func _ready():
	GameData.dead = self

func start():
	show()
	$Tween.interpolate_property($text, "rect_scale", Vector2(0.5, 0.5), Vector2(1.0,1.0), 4, Tween.TRANS_SINE)
	$Tween.interpolate_property($text, "modulate", Color(1,1,1,0), Color(1,1,1,1), 6, Tween.TRANS_SINE)
	$Tween.interpolate_property($ColorRect, "modulate", Color(1,1,1,0), Color(1,1,1,0.9), 4, Tween.TRANS_SINE)
	$Tween.start()
	$Timer.start(7)
	GameData.audio.play_sound("dark souls")

func _on_Timer_timeout():
	hide()
	$ColorRect.modulate = Color(0,0,0,0)
	$text.modulate = Color(0,0,0,0)
	GameData.game_state = "menu"
