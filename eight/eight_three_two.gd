extends Node2D


@onready var flabel = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/fline
@onready var sline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer5/sline
@onready var nline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer6/nline

@onready var alphaline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/alphaline
@onready var xline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer3/xline
@onready var yline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/yline

@onready var light = $light

@onready var sprite1 = $lense/lense1
@onready var sprite2 = $lense/lense2
@onready var type = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/type

@onready var focus = $focus

var f
var s
var n

var alpha
var x
var y

var start_position : Vector2

@export var C : float = 100.0
var vx
var vy

func _ready():
	sprite1.visible = true
	sprite2.visible = false
	type.text = "(...)"

func read():
	n = get_lines(nline)
	s = get_lines(sline)
	alpha = get_lines(alphaline)
	x = get_lines(xline)
	y = get_lines(yline)

func _on_lense_body_entered(body):
	if body.name == "light":
		pass

func _on_lense_body_exited(body):
	if body.name == "light":
		pass

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_set_pressed():
	read()
	
	f = s / (n - 1)
	flabel.text = str(snapped(f, 0.01))
	if is_inf(f):
		type.text = "O.o"
	elif f < 0:
		sprite1.visible = false
		sprite2.visible = true
		type.text = "Вогнутая"
	elif f > 0:
		sprite1.visible = true
		sprite2.visible = false
		type.text = "Выпуклая"
	else:
		type.text = "где"
	
	focus.position = Vector2(650.0, 300.0 - abs(f))
	light.position = Vector2(650.0 + x, 300.0 - y)
	
	start_position = light.position



func _on_reset_pressed():
	light.set_deferred("position", Vector2(650, 20))
	light.linear_velocity = Vector2.ZERO
	
	focus.position = Vector2.ZERO

func _on_start_pressed():
	read()
	alpha = deg_to_rad(alpha)
	vx = sin(alpha) * C
	vy = cos(alpha) * C
	
	light.linear_velocity = Vector2(vx, vy)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
