extends Node

var tile_scene = preload("res://level/tile.tscn")
var level_boundary_scene = preload("res://level/level_boundary.tscn")

# ================== Variables ================== #

var TILES_RULES_PATH = "res://level/assets/tiles_rules.json"
var TILE_DIMENSION = 512
var GRID_DIMENSION = 10

var tiles_rules = {}
var grid = []

# ================== "Private" Functions ================== #

func tile_at(pos: Array):
	"""Return the tile at a position in the grid (it's NOT godot's own 'position')"""
	return grid[pos[1]][pos[0]]


func is_collapsed():
	"""Return true if all the tiles in the grid have collapsed to a single state"""
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			if not tile_at([x,y]).is_collapsed():
				return false
	
	return true


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


func get_superposed_neighbors_pos(from_pos):
	"""Return a list of the position of superposed (i.e not collapsed) 1-neighbors of the position from_pos"""
	var superposed_neighbors_pos = []

	# Sorry for the ugly naming: right here there is going to be a confusion between "_pos"=position, 
	# used everywhere else in grid.gd, and "pos_"=positive, used for the constraints in tiles_rules.json
	# I'll find something better one day, but for now let's stick to the confusion
	if from_pos[0] > 0:
		var neg_x_pos = [from_pos[0] - 1, from_pos[1]]
		if not tile_at(neg_x_pos).is_collapsed():
			superposed_neighbors_pos.append(neg_x_pos)

	if from_pos[0] < GRID_DIMENSION - 1:
		var pos_x_pos = [from_pos[0] + 1, from_pos[1]]
		if not tile_at(pos_x_pos).is_collapsed():
			superposed_neighbors_pos.append(pos_x_pos)

	if from_pos[1] > 0:
		var neg_y_pos = [from_pos[0], from_pos[1] - 1]
		if not tile_at(neg_y_pos).is_collapsed():
			superposed_neighbors_pos.append(neg_y_pos)

	if from_pos[1] < GRID_DIMENSION - 1:
		var pos_y_pos = [from_pos[0], from_pos[1] + 1]
		if not tile_at(pos_y_pos).is_collapsed():
			superposed_neighbors_pos.append(pos_y_pos)

	return superposed_neighbors_pos


func propagate_collapse(from_pos: Array):
	"""Propagate the result of the collapse of one tile to n-neighbors"""
	var stack = []
	stack.append(from_pos)

	while stack.size() > 0:
		var current_pos = stack.pop_back()
		var current_tile = tile_at(current_pos)

		for neighbor_pos in get_superposed_neighbors_pos(current_pos):
			var neighbor_tile = tile_at(neighbor_pos)
			var old_entropy = neighbor_tile.get_entropy()

			var allowed_states = {}
			for state in current_tile.superposition.keys():
				if neighbor_pos[0] > current_pos[0]:
					allowed_states.merge(tiles_rules[state]['constraints']['pos_x'])
				if neighbor_pos[0] < current_pos[0]:
					allowed_states.merge(tiles_rules[state]['constraints']['neg_x'])
				if neighbor_pos[1] > current_pos[1]:
					allowed_states.merge(tiles_rules[state]['constraints']['pos_y'])
				if neighbor_pos[1] < current_pos[1]:
					allowed_states.merge(tiles_rules[state]['constraints']['neg_y'])
			neighbor_tile.constraint_superposition(allowed_states)

			if neighbor_tile.get_entropy() != old_entropy:
				# If a neighbor has partially collapsed (i.e its superposition has changed), we add it to the 
				# stack to propagate the change to its neighbors too
				stack.append(neighbor_pos)


# ====================== "Public" functions ====================== #

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


func init_grid():
	"""Initialise the grid with all its tiles"""
	# Initialise tiles
	var tile_ref = tile_scene.instantiate()
	var all_possible_tiles = {}
	for tile in tiles_rules.keys():
		all_possible_tiles[tile] = 1

	for y in range(GRID_DIMENSION):
		var row = []
		for x in range(GRID_DIMENSION):
			var tile = tile_ref.duplicate()
			tile.set_superposition(all_possible_tiles.duplicate())
			row.append(tile)

		grid.append(row)
	
	# Create world boundaries
	var GRID_END = TILE_DIMENSION * GRID_DIMENSION

	var neg_x_boundary = level_boundary_scene.instantiate()
	neg_x_boundary.demarcate_between(Vector2(0, 0), Vector2(0, GRID_END))
	add_child(neg_x_boundary)
	var pos_x_boundary = level_boundary_scene.instantiate()
	pos_x_boundary.demarcate_between(Vector2(GRID_END, 0), Vector2(GRID_END, GRID_END))
	add_child(pos_x_boundary)
	var neg_y_boundary = level_boundary_scene.instantiate()
	neg_y_boundary.demarcate_between(Vector2(0,0), Vector2(GRID_END, 0))
	add_child(neg_y_boundary)
	var pos_y_boundary = level_boundary_scene.instantiate()
	pos_y_boundary.demarcate_between(Vector2(0,GRID_END), Vector2(GRID_END, GRID_END))
	add_child(pos_y_boundary)


func _init():
	"""Called when the node enters the scene tree for the first time"""
	load_tiles_rules()
	init_grid()


func collapse():
	"""Collapse the grid by collapsing each tile and propagating the result"""
	while not is_collapsed():
		var pos_to_collapse = get_smallest_entropy_pos()
		tile_at(pos_to_collapse).collapse()
		propagate_collapse(pos_to_collapse)


func show():
	"""Show the grid by loading textures of all the tiles"""
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = tile_at([x,y])
			tile.load_texture()
			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


# =========== For debug ============= #

func print_every_superposition():
	for x in range(GRID_DIMENSION):
		for y in range(GRID_DIMENSION):
			print(tile_at([x,y]).superposition)
