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
	if !collided:
		range -= 1
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

func collide():
	collided = true
	if dir == 0:
		$AnimatedSprite2D.flip_v = true
		pass
	if dir == 3:
		$AnimatedSprite2D.flip_h = true
		pass
	$AnimatedSprite2D.play("collision")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	pass

func _on_area_2d_body_entered(body):
	print(body.name)
	collide()
	pass 


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	if body.is_in_group("Enemies"):
		body.take_damage(dmg)
		collide()
		pass
	
