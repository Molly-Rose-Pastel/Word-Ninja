extends Node2D


func set_datapoint(letter, value):
	
	$Line2D.points[1].y = -( value + 64 )
	
	$time.bbcode_text = "[center]" + str(value)
	$letter.bbcode_text = "[center]" + str(letter)
	
	if value > 900:
		$time.rect_position.y = -( 900 + 64 + 36 )
	else:
		$time.rect_position.y = -(value + 64 + 36)
	
	var font = DynamicFont.new()
	font.font_data = load("res://fonts/DroidSans.ttf")
	font.size = 24
	font.outline_size = 1
	
	if value == 0:
		font.outline_color = Color(0,0,0,1)
	if value > 0 and value < 100:
		font.outline_color = Color(0,1,0,1)
	if value > 99 and value < 300:
		font.outline_color = Color(1,1,0,1)
	if value > 299:
		font.outline_color = Color(1,0,0,1)
	
	$time.set("custom_fonts/normal_font", font)
