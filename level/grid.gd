extends Node

var tile_scene = preload("res://level/tile.tscn")

# ================== Variables ================== #

const TILES_RULES_PATH = "res://level/assets/tiles_rules.json"
const TILE_DIMENSION = 512
const GRID_DIMENSTION = 10

var tiles_rules = {}
var grid = []

# ================== Functions ================== #

func tile_at(pos: Array):
	"""Return the tile at position pos in the grid"""
	return grid[pos[1]][pos[0]]


func get_smallest_entropy_pos():
	"""Return the position of the tile with the smallest entropy in the grid"""
	"""(NOT including collapsed tiles)"""
	var smallest_entropy_pos: Array
	var smallest_entropy = 99999

	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = tile_at([x,y])

			if tile.is_collapsed():
				continue

			var entropy = tile.get_entropy()
			if entropy < smallest_entropy:
				smallest_entropy_pos = [x, y]
				smallest_entropy = entropy

	return smallest_entropy_pos


func is_collapsed():
	"""Return true if all the tiles in the grid have collapsed to a single state"""
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			if not tile_at([x,y]).is_collapsed():
				return false
	
	return true


func collapse():
	"""Collapse the grid by collapsing each tile and propagating the result"""
	while not is_collapsed():
		var pos_to_collapse = get_smallest_entropy_pos()
		tile_at(pos_to_collapse).collapse()
		propagate_collapse(pos_to_collapse)


func propagate_collapse(from_pos: Array):
	"""Propagate the result of the collapse of one tile to n-neighbors"""
	var stack = []
	stack.append(from_pos)

	while stack.size() > 0:
		var pos = stack.pop_back()
		var tile = tile_at(pos)

		for neighbor_pos in get_superposed_neighbors_pos(pos):
			var neighbor = tile_at(neighbor_pos)
			var old_entropy = neighbor.get_entropy()

			for possible_tile in tile.superposition.keys():
				if neighbor_pos[0] > pos[0]:
					neighbor.constraint_superposition(tiles_rules[possible_tile]['constraints']['pos_x'])
				if neighbor_pos[0] < pos[0]:
					neighbor.constraint_superposition(tiles_rules[possible_tile]['constraints']['neg_x'])
				if neighbor_pos[1] > pos[1]:
					neighbor.constraint_superposition(tiles_rules[possible_tile]['constraints']['pos_y'])
				if neighbor_pos[1] < pos[1]:
					neighbor.constraint_superposition(tiles_rules[possible_tile]['constraints']['neg_y'])
			

			if neighbor.get_entropy() != old_entropy:
				# If a neighbor has partially collapsed (i.e its superposition has changed), we add it to the 
				# stack to propagate the change to its neighbors too
				stack.append(neighbor_pos)


func get_superposed_neighbors_pos(from_pos):
	"""Return a list of the position of superposed (i.e not collapsed) 1-neighbors of a position"""
	var superposed_neighbors_pos = []

	if from_pos[0] > 0:
		var neighbor_pos = [from_pos[1], from_pos[0] - 1]
		if not tile_at(neighbor_pos).is_collapsed():
			superposed_neighbors_pos.append(neighbor_pos)

	if from_pos[0] < GRID_DIMENSTION - 1:
		var neighbor_pos = [from_pos[1], from_pos[0] - 1]
		if not tile_at(neighbor_pos).is_collapsed():
			superposed_neighbors_pos.append(neighbor_pos)

	if from_pos[1] > 0:
		var neighbor_pos = [from_pos[1], from_pos[0] - 1]
		if not tile_at(neighbor_pos).is_collapsed():
			superposed_neighbors_pos.append(neighbor_pos)

	if from_pos[1] < GRID_DIMENSTION - 1:
		var neighbor_pos = [from_pos[1], from_pos[0] - 1]
		if not tile_at(neighbor_pos).is_collapsed():
			superposed_neighbors_pos.append(neighbor_pos)

	return superposed_neighbors_pos

func show():
	"""Show the grid by loading textures of all the tiles"""
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = tile_at([x,y])
			tile.load_texture()
			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


func init_grid():
	"""Initialise the grid with all its tiles"""
	var tile_ref = tile_scene.instantiate()
	var all_possible_tiles = {}
	for tile in tiles_rules.keys():
		all_possible_tiles[tile] = 1

	for y in range(GRID_DIMENSTION):
		var row = []
		for x in range(GRID_DIMENSTION):
			var tile = tile_ref.duplicate()
			tile.set_superposition(all_possible_tiles.duplicate())
			row.append(tile)

		grid.append(row)

func load_tiles_rules():
	"""Load the rules for tiles adjacency from a json file"""
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
	init_grid()
