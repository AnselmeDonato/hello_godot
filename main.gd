extends Node

var grid_scene = preload("res://level/grid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = grid_scene.instantiate()
	grid.collapse()
	grid.show()
	add_child(grid)

