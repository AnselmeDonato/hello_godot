extends Node2D

# ================== Variables ================== #

const ASSETS_PATH = "res://level/assets/"

var superposition = {}
var grid_position = [-1, -1]
# ================== Functions ================== #

func is_collapsed():
	"""Return true if the tile has collapsed to a single state"""
	if superposition.size() == 1:
		return true
	return false


func get_entropy():
	"""Return tile's entropy (i.e number of superposed states)"""
	return superposition.size()


func constraint_superposition(constraint: Dictionary):
	"""Update the states in the superposition using the provided constraint"""
	for possible_tile in superposition.keys():
		if not constraint.has(possible_tile):
			superposition.erase(possible_tile)


func load_texture():
	"""Load the texture corresponding to the collapsed single state"""

	if not is_collapsed():
		print("Error: can't load texture if the tile is not collapsed")
		return -1

	var texture_path = str(ASSETS_PATH, superposition.keys()[0], ".png")
	$Sprite2D.texture = load(texture_path)


func set_superposition(superposition_: Dictionary):
	"""Set the superposition (meant for initialisation of the tile)"""
	superposition = superposition_


func set_grid_position(grid_position_: Array):
	"""Set the position in the grid (meant for initialisation of the tile)"""
	grid_position = grid_position_


func collapse():
	"""Collapse superposition to a single state (chosen at random between superposed states)"""
	var rng = RandomNumberGenerator.new() 
	var possible = superposition.keys()
	
	var collapsed = possible[rng.randi_range(0, possible.size() - 1)]
	superposition = {collapsed: 1}

# Called when when the object's script is instantiated.
func _init():
	pass
