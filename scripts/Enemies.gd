extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func move_towards(pivot_position: Vector2, offset: Vector2):
	position = pivot_position
	position += offset
	pass
	


