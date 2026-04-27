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
var alpha : float
var s : float
var omega : float
var v : float
var t : float
var x : float
var y : float

var simulation : bool = false

func _ready():
	read()
	ball.position = Vector2(r, 0)
	write()

func _process(delta):
	if !simulation: return
	
	if t <= t0:
		t += delta
		n = nu * t
		alpha = omega * t
		x = r * cos(alpha)
		y = r * sin(alpha)
		s = v * t
		
		ball.position = Vector2(x, -y)
		write()
	elif t > t0:
		simulation = false
		
	update_tiles()


func _on_stop_pressed():
	simulation = false

func _on_go_pressed():
	read()
	t = 0
	n = 0
	alpha = 0
	x = r
	y = 0
	omega = 2 * nu * PI
	v = 2 * nu * r * PI
	ball.position = Vector2(r, 0)
	simulation = true

func write(): 
	nvalue.text = str(snapped(n, 0.01))
	avalue.text = str(snapped(alpha, 0.01))
	svalue.text = str(snapped(s, 0.01))
	ovalue.text = str(snapped(omega, 0.01))
	vvalue.text = str(snapped(v, 0.01))
	tvalue.text = str(snapped(t, 0.1))
	xvalue.text = str(snapped(x, 0.01))
	yvalue.text = str(snapped(y, 0.01))

func read():
	r = get_lines(rline)
	nu = get_lines(nuline)
	t0 = get_lines(t0line)

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func reset():
	simulation = false
	t = 0
	n = 0
	alpha = 0
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

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

func _on_reset_pressed():
	reset()

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
