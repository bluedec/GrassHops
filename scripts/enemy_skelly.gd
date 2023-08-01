extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

@onready var player = null
@onready var timer = $Timer
var speed = 39
var is_player_in_radius = false
var armor : float = 0.09
var is_staggered = false
var health : int = 15
var dead = false

func _physics_process(_delta):
	if health <= 0:
		dead = true
		print("ok..")
		timer.wait_time = 3.0
		timer.one_shot = true
		timer.autostart = true
		timer.start()
		anim.play("death")
		
	
	if dead:
		return
	
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
	print("my helth is: ", health)

func _on_timer_timeout():
	print("dying..")
	die()
	pass # Replace with function body.
