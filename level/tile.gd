extends Node2D

func load_texture(texture_path: String):
	var texture = load(texture_path)
	$Sprite2D.texture = texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
