extends CharacterBody2D

const GRAVITY = 300
const SPEED = 250

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	movement()
	pass

func movement():
	if Input.is_action_pressed("left", true):
		if Input.is_action_pressed("up"):
			position.y -= (GRAVITY / SPEED) * 1.5
			pass
		if Input.is_action_pressed("down"):
			position.y += (GRAVITY / SPEED) * 1.5
			pass
		position.x -= (GRAVITY / SPEED) * 2.5
		anim.flip_h = true
		anim.play("run")
		
	elif Input.is_action_pressed("right", true):
		if Input.is_action_pressed("up"):
			position.y -= (GRAVITY / SPEED) * 1.5
			pass
		if Input.is_action_pressed("down"):
			position.y += (GRAVITY / SPEED) * 1.5
			pass
		position.x += (GRAVITY / SPEED) * 2.5
		anim.flip_h = false
		anim.play("run")
		
	elif Input.is_action_pressed("down", true):
		position.y += (GRAVITY / SPEED) * 2.5
		anim.play("run")
		
	elif Input.is_action_pressed("up", true):
		position.y -= (GRAVITY / SPEED) * 2.5
		anim.play("run")
		
	else:
		anim.play("idle")
		
	move_and_slide()
	pass
	
