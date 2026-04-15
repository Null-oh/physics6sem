extends CanvasLayer

signal reset_pressed
signal start_pressed
signal stop_pressed

func _ready():
	$ColorRect/MarginContainer/HBoxContainer/buttons/reset.pressed.connect(_on_reset_pressed)
	$ColorRect/MarginContainer/HBoxContainer/buttons/start.pressed.connect(_on_start_pressed)
	$ColorRect/MarginContainer/HBoxContainer/buttons/stop.pressed.connect(_on_stop_pressed)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

func _on_reset_pressed():
	reset_pressed.emit()

func _on_start_pressed():
	start_pressed.emit()

func _on_stop_pressed():
	stop_pressed.emit()
