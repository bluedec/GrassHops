extends Node2D

var wave = 0
var wave_currency = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_player()
	pass

func next_wave():
	var added_currency = wave_currency * 0.3
	wave += 1
	
	pass
	
func find_player():
	
	print(get_parent().get_node("Sonny").health)
	pass
