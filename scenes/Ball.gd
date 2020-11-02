extends Area2D

export(Vector2) var velocity:= Vector2(0,0)
export(int) var ball_number := 1

var acceleration:= Vector2.ZERO
var drag = 0.4
var dragging = false
var hit_force = 3
var sprite_radius = 15
var collision_calculated_by_other_ball := false

signal ball_in_hole(ball)

onready var velocityLine2D = $VelocityLine2D
onready var trajectoryLine2D = $TrajectoryLine2D

func _ready():
	$Sprite.texture = load("res://assets/sprites/ball_%d.png" % [ball_number])
	connect("area_entered", self, "_area_entered")

func _input(event):
	if is_white_ball():
		if event is InputEventMouseButton:
			if(event.button_index == BUTTON_RIGHT && dragging):
				dragging = false
			if(!dragging && event.pressed && event.position.distance_to(global_position) < 30 ):
				dragging = true
			elif(dragging && !event.pressed):
				velocity = (global_position - event.position) * hit_force
				dragging = false

func _process(delta):
	clear_line_points(velocityLine2D)
	clear_line_points(trajectoryLine2D)
	if(dragging):
		var mouse_position = get_viewport().get_mouse_position()
		velocityLine2D.add_point(global_position)
		velocityLine2D.add_point(mouse_position)
		if(GameOptions.show_trajectory):
			clear_line_points(trajectoryLine2D)
			trajectoryLine2D.add_point(global_position)
			var r = global_position - mouse_position
			trajectoryLine2D.add_point(global_position + r * 2)


func _physics_process(delta):
	acceleration = - velocity * drag
	velocity = velocity + acceleration * delta
	if velocity.length() > 3:
		position += velocity * delta
	else:
		velocity = Vector2.ZERO

func _area_entered(other):
	if(other.is_in_group("walls")):
		velocity = velocity.bounce(other.wall_normal.normalized())
	
	if(other.is_in_group("holes")):
		emit_signal("ball_in_hole", self)
	
	if(other.is_in_group("balls")):
		if(!collision_calculated_by_other_ball):
			other.collision_calculated_by_other_ball = true
			
			# Calculate the angle of the line-of-action
			var theta = (other.global_position - global_position).angle()

			var c = cos(theta)
			var s = sin(theta)

			# Determine the velocity components along the line of action and normal to it
			var u1p =  velocity.x * c + velocity.y * s
			var u1n = -velocity.x * s + velocity.y * c
			var u2p =  other.velocity.x * c + other.velocity.y * s
			var u2n = -other.velocity.x * s + other.velocity.y * c

			# Compute the post-collision velocities
			var v1p = u2p
			var v1n = u1n
			var v2p = u1p
			var v2n = u2n

			# Rotate the post-collision velocities back to the original Cartesian coordinate system.
			var v1x = v1p * c - v1n * s
			var v1y = v1p * s + v1n * c
			var v2x = v2p * c - v2n * s
			var v2y = v2p * s + v2n * c
			
			# Reassign velocities
			velocity = Vector2(v1x, v1y)
			other.velocity = Vector2(v2x, v2y)
		else:
			collision_calculated_by_other_ball = false
		

func clear_line_points(line):
	line.global_position = Vector2.ZERO
	line.global_rotation = 0
	line.clear_points()

func is_white_ball():
	return (ball_number == 16)
