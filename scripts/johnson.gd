extends CharacterBody2D

@onready var speed = 120
@onready var anim = $AnimatedSprite2D
var combo : int = 0
var combo_cooldown : float = 0.5

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	input_direction.normalized()
	
	if input_direction.x > 0:
		anim.flip_h = false
		anim.play("run")
		calculate_velocity_and_slide(input_direction)
		return
	elif input_direction.x < 0:
		anim.flip_h = true
		anim.play("run")
		calculate_velocity_and_slide(input_direction)
		return
	elif input_direction.y > 0 or input_direction.y < 0:
		anim.play("run")
		calculate_velocity_and_slide(input_direction)
		return
	else:
		anim.play("idle")
		
	combo_cooldown -= 0.01
	if Input.is_action_pressed("basic_attack"):
		attack(combo)
		
	calculate_velocity_and_slide(input_direction)
	
func attack(combo):
	if combo == 0:
		anim.play("punch")
		await anim.animation_finished
		combo += 1
	elif combo == 1:
		if combo_cooldown <= 0:
			anim.play("punch_2")
			await anim.animation_finished
			combo += 1
			combo_cooldown = 0.5
	else:
		anim.play("idle")
		combo = 0
		combo_cooldown = 0.5
	

func calculate_velocity_and_slide(input_direction):
	velocity = input_direction * speed
	move_and_slide()
	
func _on_punch_animation_finished():
	print("Animation finished.")
