extends Node2D

# ================== Variables ================== #

const ASSETS_PATH = "res://level/assets/"

var possible_tiles = {}

# ================== Functions ================== #

func is_collapsed():
	if possible_tiles.size() == 1:
		return true
	return false



func get_entropy():
	return possible_tiles.size()



func load_texture():
	if not is_collapsed():
		print("Error: can't load texture if the tile is not collapsed")
		return -1

	var texture_path = str(ASSETS_PATH, possible_tiles.keys()[0], ".png")
	$Sprite2D.texture = load(texture_path)



func set_possible_tiles(possible_tiles_: Dictionary):
	possible_tiles = possible_tiles_



func collapse():
	var rng = RandomNumberGenerator.new() 
	var possible = possible_tiles.keys()
	
	var collapsed = possible[rng.randi_range(0, possible.size() - 1)]
	possible_tiles = {collapsed: 1}

# Called when when the object's script is instantiated.
func _init():
	pass
