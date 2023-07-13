extends CharacterBody2D

const SPEED = 25

@onready var anim = $AnimatedSprite2D
var is_player_in_radius = false
var player = null

func _physics_process(delta):
	if is_player_in_radius: 
		position += (player.position - position) / SPEED
		anim.play("walk")

func _on_detection_area_body_entered(body):
	player = body
	is_player_in_radius = true


func _on_detection_area_body_exited(body):
	player = null
	is_player_in_radius = false

