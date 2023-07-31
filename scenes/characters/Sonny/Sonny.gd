extends CharacterBody2D

@onready var speed = 120
@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sword_hitbox : Area2D = $Sword_Hitbox_Detector
@onready var sword_shape : CollisionShape2D = $Sword_Hitbox_Detector/Sword_Hitbox

var combo : int = 0
var combo_cooldown : float = 0.5
var dir = "down"
var dmg : int = 49

func _ready():
	pass

func _process(_delta):
	sword_shape.disabled = true
	if Input.is_action_just_pressed("basic_attack"):
		attack()
		
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	input_direction.normalized()
	
	var moving = input_direction.x != 0 or input_direction.y != 0
	
	if is_attacking():
		input_direction = input_direction * 0.1
				
	handle_movement(input_direction)
	
	if is_attacking():
		return

	
	if dir == "left":
		if moving:
			anim.play("left_side_running")
		else:
			anim.play("left_side_idle")

	elif dir == "right":
		if moving:
			anim.play("right_side_running")
		else:
			anim.play("right_side_idle")
#
	elif dir == "down":
		if moving:
			anim.play("running_front")
		else:
			anim.play("idle")
			
	elif dir == "up":
		if moving:
			anim.play("running_upwards")
		else:
			anim.play("upwards_idle")

	combo_cooldown -= 0.01

func handle_movement(input_direction):
	
	if input_direction.x > 0:
		dir = "right"
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.x < 0:
		dir = "left"
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.y > 0:
		dir = "down"
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.y < 0:
		dir = "up"
		calculate_velocity_and_slide(input_direction)
		
		
func is_attacking():
	return anim.current_animation == "attack_down" \
	or anim.current_animation == "left_side_attack" \
	or anim.current_animation == "right_side_attack"
	
func attack():
	if dir == "down":
		anim.play("attack_down")
		
		sword_shape.disabled = false
	elif dir == "left":
		anim.play("left_side_attack")
	elif dir == "right":
		anim.play("right_side_attack")

#	if combo == 0:
#		if dir == "down":
#			anim.play("attack_down")
#		elif dir == "left":
#			anim.play("left_side_attack")
#		elif dir == "right":
#			anim.play("right_side_attack")
#		combo += 1
#	elif combo == 1:
#		if combo_cooldown <= 0:
#			anim.play("")
#			combo_cooldown = 0.5
#			combo += 1
#	else:
#		combo = 0
#		combo_cooldown = 0.5
	

func calculate_velocity_and_slide(input_direction):
	velocity = input_direction * speed
	move_and_slide()
	

func _on_sword_hitbox_detector_body_entered(body):
	pass # Replace with function body.
