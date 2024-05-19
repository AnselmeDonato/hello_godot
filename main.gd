extends Node

@export var tile_scene: PackedScene

const FORMAT_TEXTURE_PATH = "res://level/assets/%s"

const RED_TILE_INT = 0
const BLUE_TILE_INT = 1

const TILE_DIMENSION = 512
const GRID_DIMENSTION = 10

var grid = []
var tiles_to_collapse_position = []

# Initialize map grid with dictionnaries of all possible tiles
func initialize_grid(grid_dimentsion: int):
	var all_possible_tiles = [RED_TILE_INT, BLUE_TILE_INT]
	all_possible_tiles.sort()

	for y in range(grid_dimentsion):
		var row = []
		for x in range(grid_dimentsion):
			row.append(all_possible_tiles)
			tiles_to_collapse_position.append([x,y])
		grid.append(row)


func collapse_grid():
	var rng = RandomNumberGenerator.new()

	while tiles_to_collapse_position.size() > 0:
		var tile_position = tiles_to_collapse_position.pop_at(rng.randi_range(0, tiles_to_collapse_position.size() - 1))
		var tile = grid[tile_position[0]][tile_position[1]]
		var collapsed_tile = tile[rng.randi_range(0, tile.size() - 1)]

		grid[tile_position[0]][tile_position[1]] = collapsed_tile

func show_grid():
	for y in range(grid.size()):
		for x in range(grid[0].size()):
			var tile = tile_scene.instantiate()

			match grid[x][y]:
				RED_TILE_INT:
					tile.load_texture(FORMAT_TEXTURE_PATH % "red_256.png")
				BLUE_TILE_INT:
					tile.load_texture(FORMAT_TEXTURE_PATH % "blue_256.png")

			tile.position = Vector2(x * TILE_DIMENSION, y * TILE_DIMENSION)
			add_child(tile)


func build_tile_grid(grid_dimension: int):
	initialize_grid(grid_dimension)
	collapse_grid()
	show_grid()

# Called when the node enters the scene tree for the first time.
func _ready():
	build_tile_grid(10)

