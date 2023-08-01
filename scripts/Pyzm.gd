extends RigidBody2D

var health = 100
var damage = 10
var player = null
var gravity_applied : float = 0.001


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player:
		sleeping = true
		return
	
	$Sprite2D/AnimationPlayer.play("jump")
	
	if player.position.y > position.y:
		gravity_scale = 0.01
		print("player is down")
	else:
		gravity_scale = -0.01
		print("player is up")
		
	if player.position.x > position.x:
		constant_force.x = 1
		print("player is right")
	else:
		constant_force.x = -1
		print("player is left")
	

	print(gravity_applied)
	


func _on_bio_scanner_body_entered(body):
	if body.name == "Sonny":
		player = body

func take_damage(dmg):
	health -= dmg
	pass


func _on_damage_dealer_body_entered(body):
	body.take_damage(damage)
	pass # Replace with function body.
