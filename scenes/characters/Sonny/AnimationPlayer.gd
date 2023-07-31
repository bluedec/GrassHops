extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_finished(anim_name):
	print(anim_name, " finished")
	if anim_name == "attack_down" or "left_side_attack" or "right_side_attack":
		print("lol")
		# resume
	
