extends Node2D

var health = 5
onready var start_position = get_parent().get_node("tools/nina_position").global_position
var enemy
var slash


func _ready():
	GameData.ninja = self

func _process(_delta):
	$health.value = health


func reset():
	health = 5
	$idle.show()
	$idle.play()
	$attack.stop()
	$attack.frame = 0
	$attack.hide()
	$die.stop()
	$die.frame = 0
	$die.hide()

func attack(device):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$idle.hide()
	$attack.show()
	$attack.play()
	$Tween.interpolate_property(self, "global_position", global_position, device.global_position, 0.1, Tween.TRANS_LINEAR)
	$Tween.start()
	enemy = device
	GameData.audio.play_sound("hit")

func die():
	GameData.level.stop()
	GameData.audio.play_sound("die")
	$idle.hide()
	$die.show()
	$die.play()


func _on_attack_animation_finished():
	$attack.stop()
	$attack.frame = 0
	$attack.hide()
	$idle.show()
	$Tween.interpolate_property(self, "global_position", global_position, start_position, 0.05, Tween.TRANS_SINE)
	$Tween.start()

func _on_attack_frame_changed():
	if $attack.frame == 4:
		enemy.destroy()


func _on_Area2D_area_entered(area):
	area.get_parent().blowup()
	var random_number = int(rand_range(0, 2))
	slash = $slashes.get_children()[random_number]
	slash.show()
	slash.play()
	health -= 1
	if health == 0:
		die()

func _on_Tween_tween_all_completed():
	if global_position == start_position:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)


func _on_slash_animation_finished():
	slash.stop()
	slash.frame = 0
	slash.hide()
