extends Node2D

enum {IDLE, MOVING}

var state

func _ready():
	state = IDLE
	
	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		ball.connect("ball_in_hole", self, "_ball_in_hole")

func _ball_in_hole(ball_number):
	print("Ha entrado la bola ", ball_number)
