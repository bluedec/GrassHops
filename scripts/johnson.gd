extends CharacterBody2D

@onready var speed = 120
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if input_direction.x > 0:
		anim.flip_h = false
		anim.play("run")
		pass
	elif input_direction.x < 0:
		anim.flip_h = true
		anim.play("run")
		pass
	elif input_direction.y > 0 or input_direction.y < 0:
		anim.play("run")
		pass
	else:
		anim.play("idle")
		pass
		
	velocity = input_direction * speed
	move_and_slide()
	
