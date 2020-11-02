extends Node2D

const Ball = preload("res://scenes/Ball.tscn")
const ball_radius = 15

var balls_coordinates = {
	1: Vector2(4,0),
	2: Vector2(2,-1),
	3: Vector2(2,1),
	4: Vector2(0,-2),
	5: Vector2(0,2),
	6: Vector2(-2,-3),
	7: Vector2(-2,-1),
	8: Vector2(0,0),
	9: Vector2(-2,1),
	10: Vector2(-2,3),
	11: Vector2(-4,-4),
	12: Vector2(-4,-2),
	13: Vector2(-4,0),
	14: Vector2(-4,2),
	15: Vector2(-4,4),
}

func _ready():
	for ball_number in balls_coordinates:
		var ball = Ball.instance()
		ball.global_position = ball_radius * balls_coordinates[ball_number]
		ball.ball_number = ball_number
		add_child(ball)

