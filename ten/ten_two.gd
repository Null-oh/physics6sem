extends Node2D

@onready var mass = $mass

@onready var ro1line = $interface/ColorRect/MarginContainer/HBoxContainer/input/first/ro1line
@onready var ro2line = $interface/ColorRect/MarginContainer/HBoxContainer/input/second/ro2line
@onready var vline = $interface/ColorRect/MarginContainer/HBoxContainer/input2/f/vline

@onready var result = $interface/ColorRect/MarginContainer/HBoxContainer/input2/f2/result

var ro1 #water
var ro2 #mass
var v

func _ready():
	pass

func _process(delta):
	pass

func read():
	ro1 = get_lines(ro1line)
	ro2 = get_lines(ro2line)
	v = get_lines(vline)

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_start_pressed():
	read()
	#mg = ro2 * v * g
	#fa = ro1 * v * g
	
	#sink: ro2 > ro1
	#float: ro2 < ro1
	#nothing: ro2 = ro1
	print("ro1 = ", ro1)
	print("ro2 = ", ro2)
	if ro2 == ro1:
		_float(mass)
		result.text = "Дрейфует"
	elif ro2 > ro1:
		sink(mass)
		result.text = "Тонет"
	else:
		oscillate(mass)
		result.text = "Всплывает"

func oscillate(body):
	var start_y = body.position.y
	var tween = create_tween()
	
	tween.tween_property(body, "position:y", 130, 0.3)
	
	tween.tween_property(body, "position:y", 130 - 20, 0.2)
	tween.tween_property(body, "position:y", 130, 0.2)
	
	tween.tween_property(body, "position:y", 130 - 15, 0.15)
	tween.tween_property(body, "position:y", 130, 0.15)
	
	tween.tween_property(body, "position:y", 130 - 5, 0.1)
	tween.tween_property(body, "position:y", 130, 0.1)

func sink(body):
	var start_y = body.position.y
	var tween = create_tween()
	
	tween.tween_property(body, "position:y", 405, 2.0).set_ease(Tween.EASE_OUT)

func _float(body):
	var start_a = body.rotation
	var tween = create_tween()
	
	tween.tween_property(body, "rotation", start_a + PI/12, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(body, "rotation", start_a, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(body, "rotation", start_a - PI/12, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(body, "rotation", start_a, 0.3).set_ease(Tween.EASE_OUT)

func _on_reset_pressed():
	ro1 = 0
	ro2 = 0
	v = 0
	mass.position = Vector2(510, 200)
	mass.rotation = 0

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
