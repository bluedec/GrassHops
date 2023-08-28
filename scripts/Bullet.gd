extends Node2D

var range = 700
var dir : int = 0
var dmg : int = 0
var collided : bool = false
@export var speed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("travelling")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !collided:
		range -= 1
		if range < 1:
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

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Obstacles"):
		collide()
		pass
	if body.is_in_group("Enemies"):
		collide()
		body.take_damage(dmg)
		pass
	
