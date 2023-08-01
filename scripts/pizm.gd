extends CharacterBody2D

var player = null
var jump_strength = Vector2(0, 150.0)
var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player:
		var direction = player.position - position 
		direction = direction.normalized()
		move_towards_player(player.position)
		move_and_slide()
	

func move_towards_player(player_position):
	if player_position.x < position.x or player_position.y < position.y:
		position.x -= speed
		position.y -= speed
		
	if player_position.x > position.x or player_position.y > position.y:
		position.x += speed
		position.y += speed 
		

func _on_bio_scanner_body_entered(body):
	player = body
	print(player, " is here!")
	print("position: ", player.position)
	pass


func _on_bio_scanner_body_exited(body):
	print("he left..")
	player = null
	pass # Replace with function body.
