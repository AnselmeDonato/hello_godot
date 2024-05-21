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

func get_smallest_entropy_tile():
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

func is_collapsed():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			if not grid[y][x].is_collapsed():
				return false
	
	return true

func collapse():
	var failsafe = 0
	while not is_collapsed():
		var collapse_tile = get_smallest_entropy_tile()
		collapse_tile.collapse()
		propagate_collapse(collapse_tile)

		# 97 To remove once done
		failsafe += 1
		if failsafe == 10000:
			print('HELP')
			return 1

func propagate_collapse(from_tile):
	var stack = []
	stack.append(from_tile)

	while stack.size() > 0:
		var tile = stack.pop_back()

		for neighbor in get_superposed_neighbors(tile):
			var initial_possible_tiles_size = neighbor.possible_tiles.size()

			for possible_tile in tile.possible_tiles.keys():
				if neighbor.grid_position[0] > tile.grid_position[0]:
					neighbor.check_possible_tiles_against_constraint(tiles_rules[possible_tile]['possible_neighbors']['pos_x'])
				if neighbor.grid_position[0] < tile.grid_position[0]:
					neighbor.check_possible_tiles_against_constraint(tiles_rules[possible_tile]['possible_neighbors']['neg_x'])
				if neighbor.grid_position[1] > tile.grid_position[1]:
					neighbor.check_possible_tiles_against_constraint(tiles_rules[possible_tile]['possible_neighbors']['pos_y'])
				if neighbor.grid_position[1] > tile.grid_position[1]:
					neighbor.check_possible_tiles_against_constraint(tiles_rules[possible_tile]['possible_neighbors']['neg_y'])
			
			if neighbor.possible_tiles.size() != initial_possible_tiles_size:
				stack.append(neighbor)


func get_superposed_neighbors(from_tile):
	var from_position = from_tile.grid_position
	var superposed_neighbors = []

	if from_position[0] > 0:
		var neighbor = grid[from_position[1]][from_position[0] - 1]
		if not neighbor.is_collapsed():
			superposed_neighbors.append(neighbor)
			
	if from_position[0] < GRID_DIMENSTION:
		var neighbor = grid[from_position[1]][from_position[0] + 1]
		if not neighbor.is_collapsed():
			superposed_neighbors.append(neighbor)

	if from_position[1] > 0:
		var neighbor = grid[from_position[1] - 1][from_position[0]]
		if not neighbor.is_collapsed():
			superposed_neighbors.append(neighbor)

	if from_position[0] < GRID_DIMENSTION:
		var neighbor = grid[from_position[1] + 1][from_position[0]]
		if not neighbor.is_collapsed():
			superposed_neighbors.append(neighbor)

	return superposed_neighbors

func show():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = grid[y][x]
			tile.load_texture()
			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


func build():
	var all_possible_tiles = {}
	for tile in tiles_rules.keys():
		all_possible_tiles[tile] = 1

	for y in range(GRID_DIMENSTION):
		var row = []
		for x in range(GRID_DIMENSTION):
			var tile = tile_scene.instantiate()
			tile.set_possible_tiles(all_possible_tiles)
			tile.set_grid_position([x, y])
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
	build()
