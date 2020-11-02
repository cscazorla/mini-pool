extends Node2D

var score = 0

enum {IDLE, MOVING}

var state
var balls_alive

func _ready():
	state = IDLE
	update_score()
	
	var balls = get_tree().get_nodes_in_group("balls")
	balls_alive = balls.size()
	for ball in balls:
		ball.connect("ball_in_hole", self, "_ball_in_hole")

func _ball_in_hole(ball):
	if(ball.ball_number == 16):
		ball.velocity = Vector2.ZERO
		ball.global_position = Vector2(750,400)
		score -= 10
	else:
		get_node("Hud/HBoxContainer/BallRect%d" % [ball.ball_number]).modulate.a = 1 
		score += 10
		ball.queue_free()
		balls_alive -= 1
		if(balls_alive == 1): # Only the white ball remains
			win()
	update_score()

func update_score():
	$Hud/ScoreLabel.set_text("Score: %05d" % score)

func win():
	print("Player wins!!")
	get_tree().paused = true
