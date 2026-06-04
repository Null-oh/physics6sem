extends Node2D

@onready var light1 = $light1
@onready var light2 = $light2

@export var C : float = 100.0

@onready var f1label = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/fline
@onready var sline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer5/sline
@onready var nline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer6/nline

@onready var alphaline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/alphaline
@onready var xline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/xline
@onready var yline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/yline

@onready var sprite1 = $lense/sprite1
@onready var sprite2 = $lense/sprite2
@onready var type = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/type

@onready var lense = $lense
@onready var focus = $focus

var x
var y
var alpha
var start_position : Vector2

var f
var s
var n

var is_moving : bool = false
var vx
var vy

func _ready():
	light1.gravity_scale = 0
	sprite1.visible = true
	sprite2.visible = false
	
	start_position = Vector2.ZERO

func refract(lens: Area2D, light: RigidBody2D):
	var offset = light.position.x - lens.position.x
	print("Offset: ", offset)
	print("Start Y: ", start_position.y)
	print("Lens Y ± f: ", lens.position.y + f, " or ", lens.position.y - f)
	var v = light.linear_velocity
	var speed = v.length()
	
	var alpha_in = atan2(v.x, v.y)
	var alpha_out
	
	if is_equal_approx(start_position.y, lens.position.y + f) or is_equal_approx(start_position.y, lens.position.y - f):
		if is_equal_approx(start_position.x, lens.position.x):
			alpha_out = 0
		else:
			alpha_out = alpha_in - offset / f
	elif alpha_in == 0:
		alpha_out = - offset / f
	else:
		alpha_out = alpha_in - offset / f
	
	var new_vx = speed * sin(alpha_out)
	var new_vy = speed * cos(alpha_out)
	
	light.linear_velocity = Vector2(new_vx, new_vy)
	print("alpha_out = ", alpha_out)

func read():
	x = get_lines(xline)
	y = get_lines(yline)
	alpha = get_lines(alphaline)
	s = get_lines(sline)
	n = get_lines(nline)

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_set_pressed():
	read()
	
	f = s / (n - 1)
	if f < 0: #вогнутая
		sprite1.visible = false
		sprite2.visible = true
		type.text = "Вогнутая"
	else:
		sprite1.visible = true
		sprite2.visible = false
		type.text = "Выпуклая"
	f1label.text = str(snapped(f, 0.01))
	
	light1.position.x += x
	light1.position.y = lense.position.y - y
	start_position = light1.position
	
	focus.position.x = 650
	focus.position.y = lense.position.y - f


func _on_reset_pressed():
	is_moving = false
	
	light1.set_deferred("position", Vector2(650, 100))
	
	light1.linear_velocity = Vector2.ZERO
	
	start_position = Vector2.ZERO
	
	f1label.text = "..."


func _on_start_pressed():
	read()
	is_moving = true
	
	alpha = deg_to_rad(float(alphaline.text))
	vx = sin(alpha) * C
	vy = cos(alpha) * C
	
	light1.linear_velocity = Vector2(vx, vy)


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")


func _on_lense_body_entered(body):
	refract(lense, body)
