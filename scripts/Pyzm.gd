extends RigidBody2D

var health = 100
var damage = 10
var player = null
var follow_speed = 0.1

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
		mass = 0.1
	
	$Sprite2D/AnimationPlayer.play("jump")
	
	if player.position.y > position.y:
		gravity_scale = 0.03
	else:
		gravity_scale = -0.03
	if player.position.x > position.x:
		$Sprite2D.flip_h = true
		constant_force.x = 1.3
	else:
		$Sprite2D.flip_h = false
		constant_force.x = -1.3


func _on_bio_scanner_body_entered(body):
	if body.name == "Sonny":
		player = body

func take_damage(dmg, knockback_direction):
	suffer_knockback(knockback_direction)
	var r_value = modulate.r
	modulate.r = 255
	await get_tree().create_timer(0.1).timeout
	modulate.r = r_value
	health -= dmg
	pass

func suffer_knockback(knockback_direction):
	set_axis_velocity(knockback_direction)
	pass
	
func die():
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
	body.take_damage()
	

func _on_bio_scanner_body_exited(body):
	if body.name == "Sonny":
		go_sleep()
		player = null
	

