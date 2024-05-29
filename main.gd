extends Node

var grid_scene = preload("res://level/grid.tscn")
var player_scene = preload("res://player/player.tscn")
var boid_scene = preload("res://png/boid.tscn")

const GRID_DIMENSION = Vector2i(7, 4)

# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = grid_scene.instantiate().with_data(GRID_DIMENSION)
	grid.collapse()
	grid.show()
	add_child(grid)

	var level_dimension = grid.level_dimension()

	var player = player_scene.instantiate()
	var center_grid = Vector2(level_dimension[0] / 2, level_dimension[1] / 2)
	player.set_position(center_grid)
	add_child(player)

	var rng = RandomNumberGenerator.new()
	var boid = boid_scene.instantiate()
	var random_position = Vector2(rng.randf_range(0, level_dimension[0]),rng.randf_range(0, level_dimension[1]))
	boid.set_position(random_position)
	add_child(boid)

