extends Node2D

@export var pyzm_scene = preload("res://scenes/enemies/Pyzm.tscn")
@export var active = true

var wave = 0
var wave_currency : int = 10
var player_position = null
var spawn_diddle = Vector2(-10, -10)
@onready var enemies_node = get_parent().get_node("Enemies")
@onready var player_position_timer = $Player_Position_Timer
@onready var new_wave_timer = $Mob_Timer
@onready var tick = $tick
@onready var player = get_parent().get_node("Sonny")


func _ready():
	if active:
		player_position_timer.connect("timeout", func(): player_position = player.position)
		player_position_timer.wait_time = 10
		player_position_timer.autostart = true
		player_position_timer.one_shot = false
		player_position_timer.start()
		player_position_timer.connect("timeout", find_player)
		new_wave_timer.wait_time = 5
		new_wave_timer.connect("timeout", next_wave)
		new_wave_timer.one_shot = false
		new_wave_timer.start()
		

func _process(delta):
	pass


func spawn_pyzms(amount: int):
	var current_currency = wave_currency
	
	for i in range(amount):
		var pyzm = pyzm_scene.instantiate()
		
		add_child(pyzm)
		tick.start()
		await tick.timeout
		
	# after we spawn the enemies and deplete the waves currency, we can go back
	# to the value we had before spawning to use in the next wave
	wave_currency = current_currency
	

func next_wave():
	var added_currency = wave_currency * 0.3
	wave_currency += added_currency
	wave += 1
	var position = player.position
	spawn_pyzms(2)
	

func find_player():
	
	pass
