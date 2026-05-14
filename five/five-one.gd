extends Node2D

@onready var ball = $ball

@onready var hline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/h/hline
@onready var v0line = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/v0/v0line
@onready var alphaline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/alpha/alphaline
@onready var aline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/a/aline

@onready var tvalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/t/tvalue
@onready var xvalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/x/xvalue
@onready var yvalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/y/yvalue
@onready var svalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out1/s/svalue
@onready var lvalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out2/L/lvalue
@onready var vavalue = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out2/va/vavalue
@onready var v1value = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out2/v1/v1value

@onready var toggle_accel = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/out2/tick/three

var h : float
var v0 : float #начальная горизонтальная скорость
var alpha : float
var a : float
var t : float
var x : float
var y : float
var s : float
var l : float
var va : float #средняя
var v1 : float #конечная

const G = 9.8

var simulation : bool = false

var start_time : float = 0.0

func _ready():
	simulation = false
	read()
	write()
	ball.position = Vector2(0, 0)
	toggle_accel.button_pressed = false

func _process(_delta):
	if !simulation: 
		return
	t = Time.get_ticks_msec() / 1000.0 - start_time
	
	if a != 0:
		if!toggle_accel.button_pressed: #ускорение один раз
			x = (v0 + a * sin(alpha)) * t
			y = h + (a * cos(alpha) * t) - (0.5 * G * (t**2))
		else: #ускорение постоянно
			x = v0 * t + 0.5 * (a * sin(alpha) * (t**2))
			y = h + (0.5 * (- G + a * cos(alpha)) * (t**2))
	else:
		x = v0 * t
		y = h - 0.5*G*(t**2)
	
	
	ball.position = Vector2(x, -y) #у - отрицательный
	write()
	
	if ball.position.y >= 0:
		l = x
		write()
		simulation = false

func write():
	tvalue.text = str(snapped(t, 0.1))
	xvalue.text = str(snapped(x, 0.01))
	yvalue.text = str(snapped(y, 0.01))
	svalue.text = str(snapped(s, 0.01))
	lvalue.text = str(snapped(l, 0.01))
	vavalue.text = str(snapped(va, 0.01))
	v1value.text = str(snapped(v1, 0.01))

func read():
	h = get_lines(hline) #положительное значение
	v0 = get_lines(v0line)
	alpha = get_lines(alphaline)
	a = get_lines(aline)

func reset():
	h = 0
	v0 = 0
	alpha = 0
	t = 0
	x = 0
	y = 0
	s = 0
	l = 0
	va = 0
	v1 = 0
	write()

func integral (f: Callable, _a: float, _b: float, _n: int) -> float:
	if _n <= 0: return 0.0
	
	var _h: float = (_b - _a) / _n
	var sum: float = 0.0
	
	for i in range(_n):
		var x_i = a + i*_h
		sum += f.call(x_i)
	return  sum * h

func derivative(f: Callable, _x: float, _h: float = 0.001) -> float:
	var result: float = (f.call(_x + _h) - f.call(_x - _h))/(2.0 * _h)
	return result

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_start_pressed():
	start_time = Time.get_ticks_msec() / 1000.0
	read()
	simulation = true
	ball.position = Vector2(0, -h) #у - отрицательный

func _on_reset_pressed():
	reset()
	print("h = ", h)
	ball.position = Vector2(0, 0)
	simulation = false

func _on_stop_pressed():
	simulation = false

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
