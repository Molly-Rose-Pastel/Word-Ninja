extends Node2D

func _ready():
	GameData.menu = self
	update_menu()

func update_menu():
	
	var line_count = $menu.get_line_count()
	if line_count != 0:
		$menu.remove_line(0)
	
	$menu.push_table(3)
	
	$menu.push_cell()
	$menu.add_text("[ p ]")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\tplay")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\t")
	$menu.pop()
	
	
	$menu.push_cell()
	$menu.add_text("[ t ]")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\tstatistics")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\t")
	$menu.pop()
	
	
	$menu.push_cell()
	$menu.add_text("[ m ]")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\tmusic")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\t[ "+GameData.is_music+" ]")
	$menu.pop()
	
	
	$menu.push_cell()
	$menu.add_text("[ s ]")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\tsound")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\t[ "+GameData.is_sound+" ]")
	$menu.pop()
	
	
	$menu.push_cell()
	$menu.add_text("[ j ][ k ]")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\tword speed")
	$menu.pop()
	
	$menu.push_cell()
	$menu.add_text("\t[ "+str(GameData.level.word_speed)+" ]")
	$menu.pop()

	$menu.push_cell()
	$menu.add_text("            ")
	$menu.pop()
	$menu.push_cell()
	$menu.add_text("                          ")
	$menu.pop()
	$menu.push_cell()
	$menu.add_text("                   ")
	$menu.pop()
