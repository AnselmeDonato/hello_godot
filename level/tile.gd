extends Node2D

# ================== Variables ================== #

const ASSETS_PATH = "res://level/assets/"

var possible_tiles = {}
var possible_neighbors = {
	"up": {},
	"down": {},
	"left": {},
	"right": {}
}

var tiles_rules = {}

# ================== Functions ================== #

func get_possible_tiles():
	return possible_tiles



func get_possible_neighbors():
	return possible_neighbors



func is_collapsed():
	if possible_tiles.size() == 1:
		return true
	return false



func load_texture():
	if not is_collapsed():
		print("Error: can't load texture if the tile is not collapsed")
		return 1
	
	var texture_file = tiles_rules[possible_tiles.keys()[0]]['file']
	var texture = load(ASSETS_PATH + texture_file)
	$Sprite2D.texture = texture



func load_possible_tiles():
	var tiles_rules_path = "res://level/assets/tiles_rules.json"

	var tiles_rules_string = FileAccess.get_file_as_string(tiles_rules_path)
	var open_error = FileAccess.get_open_error()
	if open_error > 0:
		print("FileAccess open Error: at file ", tiles_rules_path)

	var json = JSON.new()
	var error = json.parse(tiles_rules_string)
	if error > 0:
		print("JSON parse Error: ", json.get_error_message(), tiles_rules_string, "at line ", json.get_error_line())
		return 1

	tiles_rules = json.data

	for possible_tile in tiles_rules.keys():
		possible_tiles[possible_tile] = 1

		possible_neighbors['up'].merge(tiles_rules[possible_tile]['possible_neighbors']['up'])
		possible_neighbors['down'].merge(tiles_rules[possible_tile]['possible_neighbors']['down'])
		possible_neighbors['left'].merge(tiles_rules[possible_tile]['possible_neighbors']['left'])
		possible_neighbors['right'].merge(tiles_rules[possible_tile]['possible_neighbors']['right'])



func collapse():
	print('here')
	var rng = RandomNumberGenerator.new() 
	var possible_tile_names = possible_tiles.keys()
	var collapsed_tile_name = possible_tile_names[rng.randi_range(0, possible_tile_names.size() - 1)]
	var collapsed_tile = tiles_rules[collapsed_tile_name]

	possible_tiles = {collapsed_tile_name: collapsed_tile}
	print(possible_tiles.size())



# Called when when the object's script is instantiated.
func _init():
	load_possible_tiles()
