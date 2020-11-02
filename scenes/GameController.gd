extends Node2D

var score = 0

enum {IDLE, MOVING}

var state

func _ready():
	state = IDLE
	update_score()
	
	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		ball.connect("ball_in_hole", self, "_ball_in_hole")

func _ball_in_hole(ball_number):
	get_node("Hud/HBoxContainer/BallRect%d" % [ball_number]).modulate.a = 1 
	score += 10
	update_score()

func update_score():
	$Hud/ScoreLabel.set_text("Score: %05d" % score)
