extends Node2D

@onready var ball = $ball
@onready var tiles = $"2dTiles"
@onready var screen_size = get_viewport().get_visible_rect().size

@onready var rline = $info/ColorRect/MarginContainer/HBoxContainer/input/R/Rvalue
@onready var nuline = $info/ColorRect/MarginContainer/HBoxContainer/input/nu/nuxvalue
@onready var t0line = $info/ColorRect/MarginContainer/HBoxContainer/input/t0/t0xvalue

@onready var nvalue = $info/ColorRect/MarginContainer/HBoxContainer/output1/N/nvalue
@onready var avalue = $info/ColorRect/MarginContainer/HBoxContainer/output1/alpha/avalue
@onready var svalue = $info/ColorRect/MarginContainer/HBoxContainer/output1/S/svalue
@onready var ovalue = $info/ColorRect/MarginContainer/HBoxContainer/output2/omega/ovalue
@onready var vvalue = $info/ColorRect/MarginContainer/HBoxContainer/output2/v/vvalue
@onready var tvalue = $info/ColorRect/MarginContainer/HBoxContainer/output2/t/tvalue
@onready var xvalue = $info/ColorRect/MarginContainer/HBoxContainer/output3/x/xvalue
@onready var yvalue = $info/ColorRect/MarginContainer/HBoxContainer/output3/y/yvalue

var r : float
var nu : float
var t0 : float

var n : float
var alpha : float #угол поворота
var write_alpha : float
var s : float
var omega : float #угловая скорость 1/с
var v : float
var time : float
var x : float
var y : float

var T : float

var simulation : bool = false

var start_time : float = 0.0
var current_time : float = 0.0

func _ready():
	ball.position = Vector2(0 ,0)
	read()
	write()

func _process(delta):
	if !simulation: return
	
	current_time = Time.get_ticks_msec() / 1000.0 - start_time
	
	if current_time <= t0:
		time += delta
		
		#omega = round(omega * 100) / 100.0
		alpha = 2 * PI * nu * current_time
		x = r * cos(alpha)
		y = r * sin(alpha)
		
		ball.position = Vector2(x, -y)
		write_alpha = rad_to_deg(alpha)
		write()
	else:
		simulation = false
		alpha = 2 * PI * nu * t0
		x = r * cos(alpha)
		y = r * sin(alpha)
		ball.position = Vector2(x, -y)
		write_alpha = rad_to_deg(alpha)
		write()
	
	update_tiles()


func _on_go_pressed():
	read()

	T = 1.0 / nu if nu != 0 else 0.0
	n = t0 / T if T != 0 else 0.0
	omega = 2.0 * PI / T if T != 0 else 0.0
	v = 2.0 * PI * r / T if T != 0 else 0.0
	s = v * t0
	
	start_time = Time.get_ticks_msec() / 1000.0
	current_time = 0.0
	
	
	time = 0.0
	alpha = 0.0
	x = r
	y = 0.0
	ball.position = Vector2(r, 0)
	write_alpha = 0.0
	simulation = true
	write()


func _on_stop_pressed():
	simulation = false

func reset():
	simulation = false
	time = 0
	n = 0
	alpha = 0
	write_alpha = 0
	x = 0
	y = 0
	r = 0
	nu = 0
	t0 = 0
	omega = 0
	v = 0
	s = 0
	ball.position = Vector2(0 , 0)
	update_tiles()
	write()

func write():
	nvalue.text = str(snapped(n, 0.01))
	avalue.text = str(snapped(write_alpha, 0.01))
	svalue.text = str(snapped(s, 0.01))
	ovalue.text = str(snapped(omega, 0.01))
	vvalue.text = str(snapped(v, 0.01))
	tvalue.text = str(snapped(time, 0.1))
	xvalue.text = str(snapped(x, 0.01))
	yvalue.text = str(snapped(y, 0.01))

func read():
	r = get_lines(rline)
	nu = get_lines(nuline)
	t0 = get_lines(t0line)

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func update_tiles():
	var tile_size = tiles.tile_set.tile_size.x
	
	var screen_center = ball.position
	var left   = ball.position.x - screen_size.x / 2
	var right   = ball.position.x + screen_size.x / 2
	var top   = ball.position.y - screen_size.y / 2
	var bottom   = ball.position.y + screen_size.y / 2
	
	var sx = floori(left / tile_size)
	var ex = floori(right / tile_size)
	var sy = floori(top / tile_size)
	var ey = floori(bottom / tile_size)
	
	tiles.clear()
	
	for xx in range(sx, ex + 1):
		for yy in range(sy, ey + 1):
			tiles.set_cell(0, Vector2i(xx, yy), 0, Vector2i(0,0))

func _on_reset_pressed():
	reset()
