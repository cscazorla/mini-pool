extends Control

var current_seconds = 0;

func _ready():
	$Timer.connect("timeout", self, "_on_every_second")

func _on_every_second():
	current_seconds += 1
	$TimeLabel.set_text("%02d:%02d" % [floor(current_seconds / 60), current_seconds % 60])
