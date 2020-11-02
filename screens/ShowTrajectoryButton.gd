extends CheckButton

func _ready():
	connect("toggled", self, "_on_ShowTrajectoryButton_toggled")

func _on_ShowTrajectoryButton_toggled(button_pressed):
	GameOptions.show_trajectory = button_pressed
