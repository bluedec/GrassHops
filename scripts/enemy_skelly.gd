extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 30
var is_player_in_radius = false
var player = null

func _physics_process(delta):
	if is_player_in_radius: 
		position += (player.position - position) / speed
		anim.play("walk")
	else:
		anim.play("idle")
		
	
func _on_detection_area_body_entered(body):
	player = body
	print("Something is in radius")
	is_player_in_radius = true


func _on_detection_area_body_exited(body):
	print("Something left radius")
	player = null
	is_player_in_radius = false

