extends Node

@export var tile_scene: PackedScene

# ================== Variables ================== #

const FORMAT_TEXTURE_PATH = "res://level/assets/%s"

const TILE_DIMENSION = 512
const GRID_DIMENSTION = 10

var grid = []

# ================== Functions ================== #

# Initialize map grid with dictionnaries of all possible tiles
func initialize_grid(grid_dimension: int):
	for y in range(grid_dimension):
		var row = []
		for x in range(grid_dimension):
			var tile = tile_scene.instantiate()
			row.append(tile)

		grid.append(row)

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

func collapse_grid():
	var failsafe = 0
	while not grid_is_collapsed():
		var tile_to_collapse = smallest_entropy_tile_in_grid()
		tile_to_collapse.collapse()
		failsafe += 1
		if failsafe == 10000:
			print('HELP')
			return 1

func show_grid():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = grid[y][x]
			tile.load_texture()
			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


func build_tile_grid(grid_dimension: int):
	initialize_grid(grid_dimension)
	collapse_grid()
	show_grid()

# Called when the node enters the scene tree for the first time.
func _ready():
	build_tile_grid(GRID_DIMENSTION)

