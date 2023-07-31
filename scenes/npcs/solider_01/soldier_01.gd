extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var emotion_controller = $Emotion 
var has_quest = false
var has_reward = false
var waiting_for_completion = true


func _physics_process(_delta):
	if has_quest:
		emotion_controller.start_question()
	elif has_reward:
		emotion_controller.start_exclamation()
	else:
		emotion_controller.idle()
	pass


func _on_area_2d_mouse_entered():
	has_quest = true
	has_reward = false
	pass 

func _on_area_2d_mouse_exited():
	has_quest = false
	has_reward = true
	pass
