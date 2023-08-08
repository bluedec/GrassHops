extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var emotion_controller = $Emotion 
var has_quest = false
var has_reward = false
var waiting_for_completion = true
var health = 55

func _physics_process(_delta):
	if health <= 0:
		visible = false
	if has_quest:
		emotion_controller.start_question()
	elif has_reward:
		emotion_controller.start_exclamation()
	else:
		emotion_controller.idle()
	pass

func take_damage(dmg, knockback_strength):
	health -= dmg

func _on_area_2d_mouse_entered():
	has_quest = true
	print("Hi!")
	has_reward = false
	pass 

func _on_area_2d_mouse_exited():
	has_quest = false
	has_reward = true
	pass


func _on_damage_receiver_area_entered(area):
	print("it must have been the wind.. ", area.get_parent().name)
	pass # Replace with function body.
