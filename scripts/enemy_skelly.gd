extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = null
@onready var timer = $Timer
var speed = 39
var is_player_in_radius = false
var armor : float = 10.1
var is_staggered = false
var health : int = 15

func _physics_process(_delta):
	if health <= 0:
		anim.play("death")
		timer.start()
		
	
	if is_player_in_radius: 
		position += (player.position - position) / speed
		anim.flip_h = (player.position.x > position.x)
		anim.play("walk")
	else:
		anim.play("idle")
		
	
func die():
	queue_free()
	
func _on_detection_area_body_entered(body):
	player = body
	is_player_in_radius = true


func _on_detection_area_body_exited(_body):
	player = null
	is_player_in_radius = false

func take_damage(dmg):
	health -= dmg * armor


func _on_area_2d_body_entered(body):
	print("somethings here, receive damage!")
	print("current helth; ", health)
	if !is_staggered:
		health -= 10

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.


func _on_timer_timeout():
	print("dying..")
	die()
	pass # Replace with function body.
