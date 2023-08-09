extends CharacterBody2D

@onready var speed = 140
@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sword_detector : Area2D = $Sword_Hitbox_Detector
@onready var sword_hitbox : CollisionShape2D = $Sword_Hitbox_Detector/Sword_Hitbox_Downwards

var combo : int = 0
var combo_cooldown : float = 0.5
var dir = 2
@export var dmg : int = 49
@export var health : int = 295
@export var knockback_strength := Vector2()
var breath_speed_slowed := 0.3

func _ready():
	var timer = Timer.new()
	timer.wait_time = 5
	
	
	pass

func _physics_process(delta):
	if !is_attacking():
		$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = true
		$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = true
		$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = true
		$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = true

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
		
	if dir == 3:
		if moving:
			anim.play("left_side_running")
		else:
			anim.play("left_side_idle")

	elif dir == 1:
		if moving:
			anim.play("right_side_running")
		else:
			anim.play("right_side_idle")
#
	elif dir == 2:
		if moving:
			anim.play("running_front")
		else:
			anim.play("idle")
			
	elif dir == 0:
		if moving:
			anim.play("running_upwards")
		else:
			anim.play("upwards_idle")

	combo_cooldown -= 0.01

func lower_breath_speed():
	if anim.current_animation == "idle" \
	or anim.current_animation == "left_side_idle":
		anim.speed_scale = breath_speed_slowed
	pass

func handle_movement(input_direction):
	if input_direction.x > 0:
		dir = 1
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.x < 0:
		dir = 3
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.y > 0:
		dir = 2
		calculate_velocity_and_slide(input_direction)
		
	elif input_direction.y < 0:
		dir = 0
		calculate_velocity_and_slide(input_direction)
		
		
func is_attacking():
	return anim.current_animation == "attack_down" \
	or anim.current_animation == "left_side_attack" \
	or anim.current_animation == "right_side_attack" \
	or anim.current_animation == "attack_up_1"
	
func attack():
	if dir == 2:
		anim.play("attack_down")
		$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = false
	elif dir == 3:
		anim.play("left_side_attack")
		$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = false
	elif dir == 1:
		anim.play("right_side_attack")
		$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = false
	elif dir == 0:
		anim.play("attack_up_1")
		$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = false

#	if combo == 0:
#		if dir == 2:
#			anim.play("attack_down")
#		elif dir == 3:
#			anim.play("left_side_attack")
#		elif dir == 1:
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
	


func attack_thrust(dir):
	if dir == 1:
		position.x += 4
	elif dir == 3:
		position.x -= 4
	elif dir == 0:
		position.y -= 4
	elif dir == 2:
		position.y += 4
	

func calculate_velocity_and_slide(input_direction):
	velocity = input_direction * speed
	move_and_slide()
	

func take_damage(dmg):
	health -= dmg
	pass


func _on_sword_hitbox_detector_area_entered(area):
	var parent = area.get_parent()
	
	if position.x > parent.position.x && dir == 3:
		knockback_strength.x = -200
	elif position.x < parent.position.x && dir == 1:
		knockback_strength.x = 200
	if position.y > parent.position.y && dir == 0:
		knockback_strength.y = -200
	elif position.y < parent.position.y && dir == 2:
		knockback_strength.y = 200
		
	parent.take_damage(dmg, knockback_strength)
	pass # Replace with function body.
