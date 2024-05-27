extends CharacterBody2D

@export var speed = 400


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

# Called when the object's script is instantiated.
func _init():
	motion_mode = MOTION_MODE_FLOATING
