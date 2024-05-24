extends Node

var grid_scene = preload("res://level/grid.tscn")
var player_scene = preload("res://player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = grid_scene.instantiate()
	grid.collapse()
	grid.show()
	add_child(grid)

	var player = player_scene.instantiate()
	var center_grid = Vector2(grid.TILE_DIMENSION * grid.GRID_DIMENSION / 2, grid.TILE_DIMENSION * grid.GRID_DIMENSION / 2)
	player.set_position(center_grid)
	add_child(player)

