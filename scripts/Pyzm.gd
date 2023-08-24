extends RigidBody2D

var health := 100
var damage := 10
var player = null
var threshold = null
var negative_threshold = null
var follow_speed := 0.1
const REGULAR_FORCE = 5
const REGULAR_NEGATIVE_FORCE = -5

# Called when the node enters the scene tree for the first time.
func _ready():
	var modulate = modulate
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	if health <= 0:
		die()
		return
		
	if !player:
		go_sleep()
		return
	else:
		mass = 0.01
		
	
	$Sprite2D/AnimationPlayer.play("jump")
	
	apply_force_to_sides()
	react_to_close_player()

	if player.position.y > position.y:
		constant_force.y = 0.4
	else:
		constant_force.y = -0.4
	if player.position.x > position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func react_to_close_player():
	if going_up() && position.y > negative_threshold:
		if player_is_left():
			constant_force.x = -3
		else:
			constant_force.x = 3
	if going_down() && position.y > threshold:
		if player_is_left():
			constant_force.x = -3
		else:
			constant_force.x = 3

func apply_force_to_sides():
		if player_is_left():
			constant_force.x = -4
		if player_is_right():
			constant_force.x = 4
		
		


func going_down() -> bool:
	return constant_force.y > 0


func going_up() -> bool:
	return constant_force.y < 0


func player_is_left() -> bool:
	if player.position.x > position.x:
		return false
	return true
	
func player_is_right() -> bool:
	if player.position.x > position.x:
		return true
	return false


func _on_bio_scanner_body_entered(body):
	if body.name == "Sonny":
		player = body
		threshold = player.position.y - 84
		negative_threshold = player.position.y + 84

func take_damage(dmg, knockback_direction=Vector2(0, 0)):
	set_axis_velocity(knockback_direction)
	var r_value = modulate.r
	modulate.r = 255
	await get_tree().create_timer(0.1).timeout
	modulate.r = r_value
	health -= dmg
	pass
	
func die():
	lock_rotation = false
	
	rotate(0.04)
		
	# drop coin?
	# give xp to player
	# play death animation
	modulate.a -= 0.01
	if modulate.a < 0.1:
		queue_free()
		

func go_sleep():
	while mass < 10:
		mass += 0.1
	gravity_scale = 0
	constant_force.x = 0
	constant_force.y = 0
	pass

func _on_damage_dealer_body_entered(body):
	body.health -= 15	
	

func _on_bio_scanner_body_exited(body):
	pass
	

