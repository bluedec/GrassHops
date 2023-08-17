extends CharacterBody2D


@export var dmg : int = 49
@export var health : int = 295
@export var knockback_strength := Vector2()


@onready var speed = 140
@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sword_detector : Area2D = $Sword_Hitbox_Detector
@onready var sword_hitbox : CollisionShape2D = $Sword_Hitbox_Detector/Sword_Hitbox_Downwards


var dashing : bool = false
var combo : int = 0
var combo_cooldown : float = 0.5
var dir = 2
var breath_speed_slowed := 0.3
var dash_charges = 3


enum DIRECTION {
	DOWN,
	UP,
	LEFT,
	RIGHT
}


func _ready():
	var timer = Timer.new()
	timer.wait_time = 5
	pass

######### EACH FRAME(right?) #########
func _physics_process(delta):
	
	if Input.is_action_just_pressed("basic_attack"):
		attack()
	
	if Input.is_action_just_pressed("dash"):
		dash_down()
	
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
	
	if dashing == true:
		return
	
	$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = true
	
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
		if dashing:
			
			pass
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
	
#########  #########

######### Functions #########
#### Most recently created is at top ####
#### Oldest is at the bottom  ####

func say(what: String):
	print(what)

func dash_down():
	anim.play("dash_down")
	dashing = true
	position.y += 45
	pass

func no_longer_dashing():
	dashing = false
	pass

func activate_extra_hitbox():
	$Sword_Hitbox_Detector/Sword_Hitbox_Right_Two.disabled = false
	pass

func deactivate_extra_hitbox():
	$Sword_Hitbox_Detector/Sword_Hitbox_Right_Two.disabled = true
	pass

func activate_weapon_hitbox(direction: int):
	if direction == 0:
		$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = false
		return
	if direction == 1:
		$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = false
		return
	if direction == 2:
		$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = false
		return
	if direction == 3:
		$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = false
		return
	pass
	
func deactivate_weapon_hitbox(direction: int):
	if direction == 0:
		$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = true
		return
	if direction == 1:
		$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = true
		return
	if direction == 2:
		$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = true
		return
	if direction == 3:
		$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = true
		return
	pass

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
	


func attack_thrust():
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
