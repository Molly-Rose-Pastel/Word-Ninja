extends Node2D

export var DataPoint : PackedScene
var spacing = 32

func _ready():
	GameData.statistics = self

func update_data():
	draw_letters()
	draw_special()

func draw_letters():
	
	if $letter_points.get_child_count() != 0:
		for unit in $letter_points.get_children():
			unit.call_deferred("queue_free")
		
	
	var letters = GameData.letter_time.keys()
	var counter = 0
	for letter in letters:
		var point = DataPoint.instance()
		var x_value = counter * spacing
		$letter_points.add_child(point)
		point.position.x = x_value
		point.set_datapoint(letter, GameData.letter_time[letter])
		counter += 1
		if counter == 52:
			break


func draw_special():
	if $special_points.get_child_count() != 0:
		for unit in $special_points.get_children():
			unit.call_deferred("queue_free")
	
	var letters = GameData.letter_time.keys()
	var counter = 0
	for letter in letters:
		if counter > 52:
			var point = DataPoint.instance()
			var x_value = (counter - 52) * spacing
			$special_points.add_child(point)
			point.position.x = x_value
			point.set_datapoint(letter, GameData.letter_time[letter])
		counter += 1


func _on_letters_pressed():
	$letter_points.show()
	$special_points.hide()

func _on_special_pressed():
	$letter_points.hide()
	$special_points.show()

func _on_back_pressed():
	hide()
	GameData.game_state = "menu"
