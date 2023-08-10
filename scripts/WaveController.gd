extends Node2D

var wave = 0
var wave_currency : int = 10
@export var pyzm_scene : PackedScene
@onready var player_position_timer = $Player_Position_Timer
@onready var new_wave_timer = $Mob_Timer
@onready var player = get_parent().get_node("Sonny")
var player_position = null


func _ready():
	new_wave_timer.wait_time = 15
	new_wave_timer.connect("timeout", next_wave)
	new_wave_timer.start()
	player_position_timer.connect("timeout", func(): player_position = player.position)
	player_position_timer.connect("timeout", func(): print("Spawning new wave!"))
	player_position_timer.wait_time = 5
	player_position_timer.autostart = true
	player_position_timer.one_shot = false
	player_position_timer.start()
	player_position_timer.connect("timeout", func(): print("looking for the players position.."))

func _process(delta):
	pass


func spawn_enemies():

	var current_currency = wave_currency
	while wave_currency > 0:
		var pyzm = pyzm_scene.instantiate()
		wave_currency -= 2
		
	# after we spawn the enemies and deplete the waves currency, we can go back
	# to the value we had before spawning to use in the next wave
	wave_currency = current_currency
	

func next_wave():
	var added_currency = wave_currency * 0.3
	wave_currency += added_currency
	
	var position = player.position
	wave += 1
	spawn_enemies()
	pass
	
func find_player():
	pass
