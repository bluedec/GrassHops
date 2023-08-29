extends CharacterBody2D

@export var dmg : int = 49
@export var health : int = 295
@export var bullet_damage : int = 15
@export var knockback_strength := Vector2()
@export var bullet_scene = preload("res://scenes/misc/bullet.tscn")

@onready var speed = 140
@onready var anim : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sword_detector : Area2D = $Sword_Hitbox_Detector
@onready var sword_hitbox : CollisionShape2D = $Sword_Hitbox_Detector/Sword_Hitbox_Downwards
@onready var dash_time = anim.get_animation("dash_down").length
@onready var new_dash_charge_timer = $Timer
@onready var bullet_down_position = $bullet_down_position

var dir : int = 2
var combo : int = 0
var dash_charges : int = 3
var combo_cooldown : float = 0.5
var breath_speed_slowed : float = 0.3

# STATES
var dashing : bool = false
#   attacking is used to disable movement and stop idle animations from playing
var attacking : bool = false
var shooting : bool = false
#   aiming is used to play the shooting idle animation
var aiming : bool = false
#   recharging is used to activate/deactivate the recharge of the dash
var recharging : bool = false

func _ready():
	var timer = Timer.new()
	timer.wait_time = 5

######### EACH FRAME(right?) #########
func _physics_process(delta):
	if !anim.current_animation.begins_with("shoot"):
		shooting = false
		
	if dashing:
		return
		
	if dash_charges < 3 && !recharging:
		recharging = true
		new_dash_charge_timer.start()
	
	if attacking:
		return
	
	if Input.is_action_just_pressed("Shoot") && !dashing && !attacking && !shooting:
		print("shooting: ", shooting)
		if dir == 0:
			anim.play("shoot_up")
			shooting = true
	
		if dir == 1:
			anim.play("shoot_right")
			shooting = true
	
		if dir == 2:
			anim.play("shoot_down")
			shooting = true
	
		if dir == 3:
			anim.play("shoot_left")
			shooting = true
	
	if Input.is_action_just_pressed("basic_attack") && !dashing:
		shooting = false
		aiming = false
		attack()
	
	if Input.is_action_just_pressed("dash") && dash_charges > 0 && !dashing:
		shooting = false
		aiming = false
		if dir == 1:
			dash_right()
			return
		if dir == 3:
			dash_left()
			return
		dash_down()
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	
	input_direction.normalized()
	
	if input_direction != Vector2.ZERO:
		aiming = false

	handle_movement(input_direction)
		
	var moving = input_direction.x != 0 or input_direction.y != 0
	
	if attacking or shooting:
		# slow the player
		input_direction = input_direction * 0.1
		
	
	# early returns
	if attacking:
		return
	
	$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = true
	$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = true
	
	if is_attacking():
		return
	
	if is_shooting():
		return
	
	if dashing:
		return

	if shooting:
		return
	
	if dir == 0:
		if aiming:
			anim.play("shoot_up_idle")
			return
		if moving:
			anim.play("running_upwards")
			return
		else:
			anim.play("upwards_idle")
			return
			
	if dir == 1:
		if aiming:
			anim.play("shoot_right_idle")
			return
		if moving:
			anim.play("right_side_running")
			return
		
		else:
			anim.play("right_side_idle")
			return
#
	elif dir == 2:
		if aiming:
			anim.play("shoot_down_idle")
			return
		if moving:
			anim.play("running_front")
			return
		else:
			anim.play("idle")
			return
			
	elif dir == 3:
		if aiming:
			anim.play("shoot_left_idle")
			return
		if moving:
			anim.play("left_side_running")
			return
		else:
			anim.play("left_side_idle")
			return
			
	combo_cooldown -= 0.01
	
#########  #########

######### Functions #########
#### Most recently at the top ####
#### Oldest at the bottom  ####

# not to be confused with the attack() function
func now_shooting():
	shooting = true

func stop_shooting():
	print("No longer shooting!!")
	shooting = false
	
func atak():
	attacking = true

func stop_atak():
	attacking = false 
	

func is_attacking() -> bool:
	return anim.current_animation == "attack_down" \
	or anim.current_animation == "left_side_attack" \
	or anim.current_animation == "right_side_attack" \
	or anim.current_animation == "attack_up_1"


func is_shooting() -> bool:
	return anim.current_animation == "shoot_down" \
	or anim.current_animation == "shoot_right" \
	or anim.current_animation == "shoot_left" \
	or anim.current_animation == "shoot_up"

func shoot_up():
	aiming = true
	shooting = true
	var bullet = bullet_scene.instantiate()
	bullet.position = $bullet_up_position.global_position
	bullet.dir = 0
	bullet.dmg = bullet_damage
	
	get_parent().add_child(bullet)
	
func shoot_right():
	aiming = true
	shooting = true
	var bullet = bullet_scene.instantiate()
	bullet.position = $bullet_right_position.global_position
	bullet.rotation = 80.2
	bullet.dir = 1
	bullet.dmg = bullet_damage
	
	get_parent().add_child(bullet)
	

func shoot_down():
	aiming = true
	shooting = true
	shooting = true
	var bullet = bullet_scene.instantiate()
	bullet.position = $bullet_down_position.global_position
	bullet.dir = 2
	bullet.dmg = bullet_damage
	
	get_parent().add_child(bullet)
	
func shoot_left():
	aiming = true
	var bullet = bullet_scene.instantiate()
	bullet.position = $bullet_left_position.global_position
	bullet.rotation = 80.2
	bullet.dir = 3
	bullet.dmg = bullet_damage
	
	get_parent().add_child(bullet)

func say(what: String):
	print(what)
	
# parameter dir is useless here, refactoring needed
func dash_thrust(dir: int):
	if dir == 0:
		position.y -= 150
		return
	if dir == 1:
		position.x += 150
		return
	if dir == 2:
		position.y += 130
		return
	if dir == 3:
		position.x -= 150
		return

func dash_right():
	anim.play("dash_right")
	dashing = true
	dash_charges -= 1
	recharging = false
	new_dash_charge_timer.stop()
	
func dash_left():
	anim.play("dash_left")
	dashing = true
	dash_charges -= 1
	recharging = false
	new_dash_charge_timer.stop()
	
func dash_down():
	anim.play("dash_down")
	dashing = true
	dash_charges -= 1
	recharging = false
	new_dash_charge_timer.stop()

func no_longer_dashing():
	dashing = false

func activate_extra_hitbox():
	$Sword_Hitbox_Detector/Sword_Hitbox_Right_Two.disabled = false

func deactivate_extra_hitbox():
	$Sword_Hitbox_Detector/Sword_Hitbox_Right_Two.disabled = true

# direction is useless and can be refactored
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
	
# direction is useless and can be refactored
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

func lower_breath_speed():
	if anim.current_animation == "idle" \
	or anim.current_animation == "left_side_idle":
		anim.speed_scale = breath_speed_slowed


func handle_movement(input_direction):
	if shooting:
		return
	if input_direction.x > 0:
		shooting = false
		dir = 1
		calculate_velocity_and_slide(input_direction)
		return
		
	elif input_direction.x < 0:
		shooting = false
		dir = 3
		calculate_velocity_and_slide(input_direction)
		return
		
	elif input_direction.y > 0:
		shooting = false
		dir = 2
		calculate_velocity_and_slide(input_direction)
		return
		
	elif input_direction.y < 0:
		shooting = false
		dir = 0
		calculate_velocity_and_slide(input_direction)
		return
		
		
	
func attack():
	atak()
	if dir == 0:
		anim.play("attack_up_1")
		$Sword_Hitbox_Detector/Sword_Hitbox_Up.disabled = false
		return
	elif dir == 1:
		anim.play("right_side_attack")
		$Sword_Hitbox_Detector/Sword_Hitbox_Right.disabled = false
		return
	elif dir == 2:
		anim.play("attack_down")
		$Sword_Hitbox_Detector/Sword_Hitbox_Downwards.disabled = false
		return
	elif dir == 3:
		anim.play("left_side_attack")
		$Sword_Hitbox_Detector/Sword_Hitbox_Left.disabled = false
		return

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
		return
	elif dir == 3:
		position.x -= 4
		return
	elif dir == 0:
		position.y -= 4
		return
	elif dir == 2:
		position.y += 4
		return
	

func calculate_velocity_and_slide(input_direction):
	velocity = input_direction * speed
	move_and_slide()
	

func take_damage(dmg):
	health -= dmg

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
		
	parent.take_damage(dmg, knockback_strength) # Replace with function body.


func _on_timer_timeout():
	print("finished!")
	recharging = false
	dash_charges += 1 # Replace with function body.
