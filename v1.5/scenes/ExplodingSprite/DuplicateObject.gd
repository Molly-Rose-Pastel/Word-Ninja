extends Sprite

var gravity = Vector2(0, 5)
var velocity = Vector2(-60, -140)
var friction = Vector2(0.9, 1)
var randomAngle
var wasVisible = false
var isBlowUp = false
var columnStep
var rowStep

func _ready():
	randomAngle = rand_range(-2, 2)

func _process(_delta):
	if isBlowUp:
		velocity = (velocity*friction) + gravity
		position += velocity
		rotation_degrees += randomAngle 

func blowUp():
	isBlowUp = true

func _on_VisibilityNotifier2D_screen_entered():
	wasVisible = true

func _on_VisibilityNotifier2D_screen_exited():
	if wasVisible:
		get_parent().duplicates.erase(self)
		call_deferred("queue_free")

func _on_Tween_tween_all_completed():
	call_deferred("queue_free")
