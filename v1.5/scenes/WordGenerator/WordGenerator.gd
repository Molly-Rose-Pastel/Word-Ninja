extends Node2D

var word_length_min = 4
var word_length_max = 8
var prng = RandomNumberGenerator.new()

var lowercase_letters = "abcdefghijklmnopqrstuvwxyz"
var uppercase_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var numbers = "0123456789"
var special_characters = "><,;.:-_#'+*`´\\?=})]([/{&%$§\"!°^"

onready var letter_weight = GameData.letter_weight


func _ready():
	prng.seed = OS.get_ticks_msec()


func generate_weighted_wordset(amount):
	
	var retval = []
	var forbidden_first_characters = []
	
	for x in range(amount):
		
		var word = ""
		
		if x == 0:
			word = generate_weighted_word()
		
		else:
			forbidden_first_characters.push_back(retval[x-1][0])
			word = generate_weighted_word()
			while( forbidden_first_characters.find(word[0]) > -1 ):
				word = generate_weighted_word()
		
		retval.push_back(word)
	
	return retval

func generate_weighted_word():
	
	var characters = lowercase_letters + uppercase_letters + numbers + special_characters
	var character_selection = []
	
	for character in range(len(characters)):
		var amount = letter_weight[character].to_int()
		if amount == 0:
			amount = 20
		for _x in range (amount):
			character_selection.push_back(characters[character])
	randomize()
	character_selection.shuffle()
	
	var retval = ""
	var length = prng.randi_range(word_length_min, word_length_max)
	
	for _x in range(length):
		retval += character_selection.front()
		character_selection.pop_front()
	
	return retval


func test_distribution():
	
	letter_weight = "00000000000000000000000099"+"66000000000000000000000000"+"0000003300"+"00000000000000000000000000000000000"
	
	var time = OS.get_ticks_msec()	
	
	var test = []
	for _x in range(1000):
		var wordset = generate_weighted_wordset(10)
		test.push_back(wordset)
	
	print("took: " + str( (OS.get_ticks_msec() - time)/1000.0 ) + "s\n")
	
	var characters = lowercase_letters + uppercase_letters + numbers + special_characters
	var dict = {}
	
	for character in characters:
		dict[character] = 0
	
	for sub_array in test:
		for wordset in sub_array:
			for character in wordset:
				dict[character] += 1
	
	var values = dict.values()
	var amount = 0.0
	
	for x in values:
		amount += x
	
	print("y: " + str( (dict["y"] / amount) * 100.0) + "%")
	print("z: " + str( (dict["z"] / amount) * 100.0) + "%")
	print("A: " + str( (dict["A"] / amount) * 100.0) + "%")
	print("B: " + str( (dict["B"] / amount) * 100.0) + "%")
	print("6: " + str( (dict["6"] / amount) * 100.0) + "%")
	print("7: " + str( (dict["7"] / amount) * 100.0) + "%")
	print("<: " + str( (dict["<"] / amount) * 100.0) + "%")
	print(">: " + str( (dict[">"] / amount) * 100.0) + "%")

