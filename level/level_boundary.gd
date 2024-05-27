extends Node

func demarcate_between(a : Vector2, b : Vector2):
	"""Set the coordinates of the boundary's shape (i.e beginning and end of the boundary)"""
	get_node("StaticBody2D/CollisionShape2D").shape.set_a(a)
	get_node("StaticBody2D/CollisionShape2D").shape.set_b(b)
