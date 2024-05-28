extends Node

var grid_scene = preload("res://level/grid.tscn")
var player_scene = preload("res://player/player.tscn")
var boid_scene = preload("res://png/boid.tscn")

const GRID_DIMENSION = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = grid_scene.instantiate().with_data(GRID_DIMENSION)
	grid.collapse()
	grid.show()
	add_child(grid)

	var player = player_scene.instantiate()
	var center_grid = Vector2(grid.TILE_DIMENSION * grid.GRID_DIMENSION / 2, grid.TILE_DIMENSION * grid.GRID_DIMENSION / 2)
	player.set_position(center_grid)
	add_child(player)

	var boid = boid_scene.instantiate()
	boid.set_position(center_grid)
	add_child(boid)

