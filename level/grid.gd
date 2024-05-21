extends Node

var tile_scene = preload("res://level/tile.tscn")

# ================== Variables ================== #

const FORMAT_TEXTURE_PATH = "res://level/assets/%s"
const TILES_RULES_PATH = "res://level/assets/tiles_rules.json"
const TILE_DIMENSION = 512
const GRID_DIMENSTION = 10

var grid = []
var tiles_rules = {}

# ================== Functions ================== #

func smallest_entropy_tile_in_grid():
	var smallest_entropy_tile
	var smallest_entropy = 99999

	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = grid[y][x]

			if tile.is_collapsed():
				continue

			var entropy = tile.get_entropy()
			if entropy < smallest_entropy:
				smallest_entropy_tile = tile
				smallest_entropy = entropy

	return smallest_entropy_tile

func grid_is_collapsed():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			if not grid[y][x].is_collapsed():
				return false
	
	return true

func collapse():
	var failsafe = 0
	while not grid_is_collapsed():
		var tile_to_collapse = smallest_entropy_tile_in_grid()
		tile_to_collapse.collapse()

		# 97 To remove once done
		failsafe += 1
		if failsafe == 10000:
			print('HELP')
			return 1

# func propagate_collapse(from_tile):
# 	var stack = []
# 	stack.append(from_tile)

# 	while stack.size() > 0:
# 		var tile = stack.pop_back()

# 		var neighbors = neighboring_tiles(tile)
# 		for neighbor in neighbors:



# func neighboring_tiles(from_tile):
# 	var from_tile_position = from_tile.grid_position
# 	var neighbors = []

# 	if from_tile_position[0] > 0:
# 		var neighbor = grid[from_tile_position[1]][from_tile_position[0] - 1]
# 		if not neighbor.is_collapsed():
# 			neighbors.append(neighbor)
			
# 	if from_tile_position[0] < GRID_DIMENSTION:
# 		var neighbor = grid[from_tile_position[1]][from_tile_position[0] + 1]
# 		if not neighbor.is_collapsed():
# 			neighbors.append(neighbor)

# 	if from_tile_position[1] > 0:
# 		var neighbor = grid[from_tile_position[1] - 1][from_tile_position[0]]
# 		if not neighbor.is_collapsed():
# 			neighbors.append(neighbor)

# 	if from_tile_position[0] < GRID_DIMENSTION:
# 		var neighbor = grid[from_tile_position[1] + 1][from_tile_position[0]]
# 		if not neighbor.is_collapsed():
# 			neighbors.append(neighbor)

func show():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = grid[y][x]
			tile.load_texture()
			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


func build_grid():
	var all_possible_tiles = {}
	for tile in tiles_rules.keys():
		all_possible_tiles[tile] = 1

	for y in range(GRID_DIMENSTION):
		var row = []
		for x in range(GRID_DIMENSTION):
			var tile = tile_scene.instantiate()
			tile.set_possible_tiles(all_possible_tiles)
			row.append(tile)

		grid.append(row)

func load_tiles_rules():
	var tiles_rules_string = FileAccess.get_file_as_string(TILES_RULES_PATH)
	var open_error = FileAccess.get_open_error()
	if open_error > 0:
		print("FileAccess open Error: at file ", TILES_RULES_PATH)

	var json = JSON.new()
	var error = json.parse(tiles_rules_string)
	if error > 0:
		print("JSON parse Error: ", json.get_error_message(), tiles_rules_string, "at line ", json.get_error_line())
		return 1

	tiles_rules = json.data


# Called when the node enters the scene tree for the first time.
func _init():
	load_tiles_rules()
	build_grid()
