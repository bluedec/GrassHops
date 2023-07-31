extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = null
var speed = 39
var is_player_in_radius = false

func _physics_process(_delta):
	if is_player_in_radius: 
		position += (player.position - position) / speed
		anim.flip_h = (player.position.x > position.x)
		anim.play("walk")
	else:
		anim.play("idle")
		
	
func _on_detection_area_body_entered(body):
	player = body
	is_player_in_radius = true


func _on_detection_area_body_exited(_body):
	player = null
	is_player_in_radius = false



