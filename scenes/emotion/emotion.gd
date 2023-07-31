extends Node2D

@onready var anim : AnimationPlayer = $emotion_sprite/AnimationPlayer

func start_question():
	anim.play("question_idle")

func start_exclamation():
	anim.play("exclamation_idle")

func idle():
	anim.play("question_idle")
