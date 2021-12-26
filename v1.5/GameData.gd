extends Node

#####     Scene References     #################################################

var game : Node2D
var level : Node2D
var ninja : Node2D
var menu : Node2D
var audio : Node2D
var statistics : Node2D
var dead : Node2D

#####     Data Structures     ##################################################

var game_state = "menu"
var is_music = "x"
var is_sound = "x"

var words = []
var Enemies = {}
var letter_time = {}
var letter_weight = ""

var lowercase_weight = ""
var uppercase_weight = ""
var numbers_weight = ""
var special_characters_weight = ""

#####      Functions     #######################################################

func _ready():
	loadData()
	extract_letter_times()

func saveData():
	var file = File.new()
	file.open("user://letter_time.json", File.WRITE)
	file.store_string( JSON.print(letter_time) )
	file.close()

func loadData():
	var file = File.new()
	if file.file_exists("user://letter_time.json"):
		file.open("user://letter_time.json", File.READ)
		var dataJson = JSON.parse(file.get_as_text())
		letter_time = dataJson.result
		file.close()
	else:
		create_default_data()
		saveData()


func extract_letter_times():
	
	var data = letter_time.values()
	
	for value in data:
		
		var value_string = "0"
		if value > 0 and value < 101:
			value_string = "1"
		if value > 100 and value < 126:
			value_string = "2"
		if value > 125 and value < 151:
			value_string = "3"
		if value > 150 and value < 201:
			value_string = "4"
		if value > 200 and value < 251:
			value_string = "5"
		if value > 250 and value < 301:
			value_string = "6"
		if value > 300 and value < 351:
			value_string = "7"
		if value > 350 and value < 401:
			value_string = "8"
		if value > 400:
			value_string = "9"

		
		letter_weight += value_string
	

func create_default_data():
	var lowercase_letters = "abcdefghijklmnopqrstuvwxyz"
	var uppercase_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var numbers = "0123456789"
	var special_characters = "><,;.:-_#'+*`´\\?=})]([/{&%$§\"!°^"
	
	var characters = lowercase_letters + uppercase_letters + numbers + special_characters
	
	for unit in characters:
		letter_time[unit] = 0
