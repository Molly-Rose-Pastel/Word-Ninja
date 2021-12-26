extends Node2D

export var friction = Vector2(0.999, 1)
export var gravity = Vector2(0, 0.5)
export var explosion_vector_length_x = 7
export var explosion_vector_length_y = 7
export var columns = 4
export var rows = 4

var columnStep
var rowStep
var width
var height
var is_duplicates = false
var duplicates = []
var sourceImageScale = Vector2.ZERO
var sourceImage
var explosion

export var DuplicateObject : PackedScene

func _process(_delta):
	if is_duplicates:
		if duplicates.empty():
			get_parent().call_deferred("queue_free")


func initialize():
	
	sourceImage = get_parent().sprite_path
	
	$Sprite.texture = sourceImage.texture
	
	width = $Sprite.texture.get_width()
	height = $Sprite.texture.get_height()

	columnStep = width / columns
	rowStep = height / rows
	sourceImageScale = $Sprite.scale
	duplicateObject()
	
	var random_number = int(rand_range(0, 2))
	explosion = $slashes.get_children()[random_number]


func duplicateObject():
	if !duplicates.empty():
		for unit in duplicates:
			unit.call_deferred("queue_free")
		duplicates.clear()
	
	var index = 0
	for row in range(rows):
		for col in range(columns):
			var unit = DuplicateObject.instance()
			add_child(unit)
			duplicates.append(unit)
			unit.hframes = rows
			unit.vframes = columns
			unit.texture = $Sprite.texture
			unit.scale = $Sprite.scale
			unit.frame = index
			unit.position = Vector2(col*columnStep*$Sprite.scale.x,
									row*rowStep*$Sprite.scale.y)
			unit.position.x -= (width/2)*$Sprite.scale.x
			unit.position.y -= (height/2)*$Sprite.scale.y
			
			unit.hide()
			
			unit.columnStep = columnStep
			unit.rowStep = rowStep
			
			index += 1
	
	is_duplicates = true

func blowUp():
	
	sourceImage.hide()
	get_parent().get_node("label").hide()
	
	for unit in duplicates:
		randomize()
		var xValue = rand_range(-explosion_vector_length_x, explosion_vector_length_x) * $Sprite.scale.x
		var yValue = rand_range(-explosion_vector_length_y / 4, -explosion_vector_length_y) * $Sprite.scale.y
		unit.gravity = gravity
		unit.velocity = Vector2(xValue, yValue)
		unit.friction = friction
		unit.gravity *= $Sprite.scale
		unit.show()
		explosion.show()
		explosion.play()
		unit.blowUp()


func _on_explosion_animation_finished():
	explosion.stop()
	explosion.frame = 0
	explosion.hide()

