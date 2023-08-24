extends Node2D

var range = 200
var dir : int = 0
var dmg : int = 0
@export var speed = 12


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("travelling")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	range -= 3
	if range < 1:
		print("freeing!")
		queue_free()
		
	advance()
	

func advance():
	if dir == 0:
		translate(Vector2(0, -speed))
	elif dir == 1:
		translate(Vector2(speed, 0))
	elif dir == 2:
		translate(Vector2(0, speed))
	elif dir == 3:
		translate(Vector2(-speed, 0))
	pass

func _on_area_2d_body_entered(body):
	print(body.name)
	pass 


func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	body.take_damage(dmg, Vector2(0, 15))
	print(body.health)
	pass # Replace with function body.
