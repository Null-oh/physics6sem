extends Node2D

@onready var ball1 = $ball1
@onready var ball2 = $ball2

@onready var head_on = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input2/head_on
@onready var which_task = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input2/task

@onready var m1line = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/m1/m1line
@onready var m2line = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/m2/m2line
@onready var v1line = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/v1/v1line
@onready var v2line = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/v2/v2line

@onready var x1value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/x/xvalue
@onready var y1value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/y/yvalue
@onready var v1value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/v1/v1value

@onready var x2value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out3/x/xvalue
@onready var y2value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out3/y/yvalue
@onready var v2value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out3/v2/v2value

@export var offset : float = 50.0

var m1 : float
var m2 : float
var v1 : float
var v2 : float

var x1 : float
var y1 : float
var v1t : float
var v1tx : float
var v1ty : float

var x2 : float
var y2 : float
var v2t : float
var v2tx : float
var v2ty : float

var alpha : float
var k : float = 0

var t : float
var start_time : float = 0.0

var impulse : float

var simulation : bool = false
var collision : bool = false

enum TASK { A1, B1, C1, A2, A3, NONE }
var task : TASK

func _ready():
	simulation = false
	collision = false
	head_on.button_pressed = false
	reset()
	read()
	write()
	
func reset_balls():
	ball1.position = Vector2(-550, -100)
	
	if task == TASK.A2 or task == TASK.A3:
		ball2.position = Vector2(0, -offset)
	else:
		ball2.position = Vector2(0, -100)


func _process(delta):
	write()
	if !simulation: 
		return
	
	t = Time.get_ticks_msec() / 1000.0 - start_time
	
	var distance = ball1.position.distance_to(ball2.position)
	if !collision and distance <= 100.0:
		collision = true
		#var overlap = 100.0 - distance
		#var direction = (ball1.position - ball2.position).normalized()
		#ball1.position += direction * (overlap / 2)
		#ball2.position -= direction * (overlap / 2)
	
	if !collision:
		ball1.position.x += v1 * delta
		ball2.position.x -= v2 * delta
	else:
		if task == TASK.A2 or task == TASK.A3:
			alpha = asin(0.01 * offset) #radius = 50 pxs
		else:
			alpha = 0
		
		v1tx = k * ( (m1 - m2) * v1 - 2 * m2 * v2) * (cos(alpha))**2 + v1 * (sin(alpha))**2
		v1ty = (k * ( (m1 - m2) * v1 - 2 * m2 * v2) - v1) * cos(alpha) * sin(alpha)
		v1t = sqrt(v1tx**2 + v1ty**2)
		#v1= v1t
		
		v2tx = k * ( (m2 - m1) * v2 - 2 * m1 * v1) * (cos(alpha))**2 - v2 * (sin(alpha))**2
		v2ty = (k * ( (m2 - m1) * v2 - 2 * m1 * v1) + v2) * cos(alpha) * sin(alpha)
		v2t = sqrt(v2tx**2 + v2ty**2)
		#v2 = v2t
		
		ball1.position.x += v1tx * delta
		ball1.position.y += v1ty * delta
		
		ball2.position.x -= v2tx * delta
		ball2.position.y -= v2ty * delta
		
	x1 = ball1.position.x
	y1 = ball1.position.y + 100
	
	x2 = ball2.position.x
	y2 = ball2.position.y + 100


func read():
	m1 = get_lines(m1line)
	m2 = get_lines(m2line)
	v1 = get_lines(v1line)
	v2 = get_lines(v2line)
	
	if m1 == 0:
		task = TASK.NONE
	else:
		if !head_on.button_pressed: #прямой, задание 1
			if m1 == m2:
				task = TASK.A1
			elif m1/m2 < 0.01: #m2 много больше m1
				task = TASK.B1
			else:
				task = TASK.C1
		elif v2 == 0: #непрямой, второе тело стоит
			task = TASK.A2
		else: #непрямой, второе тело двигается
			task = TASK.A3
	
	if !(m1 == 0 and m2 == 0):
		k = 1 / (m1 + m2)
	else:
		k = 0

func write():
	x1value.text = str(snapped(x1, 0.1))
	y1value.text = str(snapped(y1, 0.1))
	
	
	x2value.text = str(snapped(x2, 0.1))
	y2value.text = str(snapped(y2, 0.1))
	
	
	if !collision:
		v1value.text = str(snapped(v1, 0.1))
		v2value.text = str(snapped(v2, 0.1))
	else:
		v1value.text = str(snapped(v1t, 0.1))
		v2value.text = str(snapped(v2t, 0.1))
	
	match task:
		TASK.A1:
			which_task.text = " Задание 1.а "
		TASK.B1:
			which_task.text = " Задание 1.б "
		TASK.C1:
			which_task.text = " Задание 1.в "
		TASK.A2:
			which_task.text = " Задание 2 "
		TASK.A3:
			which_task.text = " Задание 3 "
		TASK.NONE:
			which_task.text = " Впишите данные! "

func reset():
	collision = false
	task = TASK.NONE
	reset_balls()
	
	m1 = 0
	m2 = 0
	v1 = 0
	v2 = 0
	
	x1 = 0
	y1 = 0
	v1t = 0
	
	x2 = 0
	y2 = 0
	v2t = 0
	
	write()

func _on_reset_pressed():
	reset()
	simulation = false

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_start_pressed():
	read()
	reset_balls()
	start_time = Time.get_ticks_msec() / 1000.0
	simulation = true

func _on_stop_pressed():
	simulation = false

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")


func _on_area_2d_body_entered(body):
	collision = true
