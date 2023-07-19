extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var quest_marker = $quest_marker
var has_quest = false
var has_reward = false
var waiting_for_completion = true


func _physics_process(delta):
	if has_quest:
		quest_marker.frame = 0
	elif has_reward:
		quest_marker.frame = 1
	elif waiting_for_completion:
		quest_marker.modulate = Color(1,1,1, 0.4)

func _on_area_2d_mouse_entered():
	sprite.frame = 1
	quest_marker.position.y -= 2
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	sprite.frame = 0
	quest_marker.position.y += 2
	pass # Replace with function body.
