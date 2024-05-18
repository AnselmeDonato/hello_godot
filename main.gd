extends Node

@export var red_tile_scene: PackedScene
@export var blue_tile_scene: PackedScene

const TILE_DIMENSION = 512

func build_tile_grid(grid_dimension: int):
	for i in range(grid_dimension):
		for j in range(grid_dimension):
			
			if((i + j)%2 == 0):
				var red_tile = red_tile_scene.instantiate()
				red_tile.position = Vector2(i * TILE_DIMENSION, j * TILE_DIMENSION)
				add_child(red_tile)
			else :
				var blue_tile = blue_tile_scene.instantiate()
				blue_tile.position = Vector2(i * TILE_DIMENSION, j * TILE_DIMENSION)
				add_child(blue_tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	build_tile_grid(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
