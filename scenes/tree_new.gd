extends StaticBody2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	if player:
		var z = player.z_index
		if player.position.y > position.y:
			z_index = z - 1


func _on_area_2d_body_entered(body):
	if body.name == "Sonny":
		player = body
