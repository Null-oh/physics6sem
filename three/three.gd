extends Node2D

@onready var ball = $ball
@onready var tiles = $"2dTiles"
@onready var screen_size = get_viewport().get_visible_rect().size

var simulation : bool = false

@onready var aline = $info/back/MarginContainer/HBoxContainer/ab/a/aline
@onready var bline = $info/back/MarginContainer/HBoxContainer/ab/b/bline
@onready var cline = $info/back/MarginContainer/HBoxContainer/cd/c/cline
@onready var dline = $info/back/MarginContainer/HBoxContainer/cd/d/dline

@onready var vx0line = $info/back/MarginContainer/HBoxContainer/ab/vx/vxline
@onready var vy0line = $info/back/MarginContainer/HBoxContainer/cd/vy/vyline

@onready var t1line = $info/back/MarginContainer/HBoxContainer/times/t1/t1line
@onready var t2line = $info/back/MarginContainer/HBoxContainer/times/t2/t2line
@onready var t3line = $info/back/MarginContainer/HBoxContainer/times/t3/t3line

@onready var tlabel = $info/back/MarginContainer/HBoxContainer/out/t/tvalue
@onready var slabel = $info/back/MarginContainer/HBoxContainer/out/s/svalue
@onready var vlabel = $info/back/MarginContainer/HBoxContainer/out/v/vvalue
@onready var accellabel = $info/back/MarginContainer/HBoxContainer/out/a/avalue

var x : float
var y : float

var a : float
var b : float
var c : float
var d : float

var vx0 : float
var vy0 : float

var t1 : float
var t2 : float
var t3 : float

var s : float
var sabs : float

var v : float
var vx : float
var vy : float

var accel : float
var accelx : float
var accely : float

var t


func _ready():
	simulation = false


func _process(delta):
	if not simulation: return
	
	if t < t2:
		t += delta
		#ax = a + b*t
		#ay = c + d*t
		
		x += vx * delta
		y += vy * delta
		
		if t >= t1:
			vx += accelx * delta
			vy += accely * delta
			
			accelx += b * delta
			accely += d * delta
			sabs = sqrt(vx**2 + vy**2)
			s += sabs * delta
		
		v = sqrt(vx**2 + vy**2)
		
		ball.position = Vector2(x ,-y)
		
		update_tiles()
		write()

func read(): 
	a = get_lines(aline)
	b = get_lines(bline)
	c = get_lines(cline)
	d = get_lines(dline)
	
	accelx = a
	accely = c
	
	vx0 = get_lines(vx0line)
	vy0 = get_lines(vy0line)
	
	t1 = get_lines(t1line)
	t2 = get_lines(t2line)
	t3 = get_lines(t3line)

func write(): 
	tlabel.text = str(snapped(t, 0.1))
	
	if t <= t2:
		slabel.text = str(snapped(s, 0.01))
	
	if t <= t3:
		v = sqrt(vx**2 + vy**2)
		vlabel.text = str(snapped(v, 0.01))
		
		accel = sqrt(accelx**2 + accely**2)
		accellabel.text = str(snapped(accel, 0.01))

func clear():
	tlabel.text = ""
	slabel.text = ""
	vlabel.text = ""
	accellabel.text = ""
	
	aline.text = ""
	bline.text = ""
	cline.text = ""
	dline.text = ""
	
	vx0line.text = ""
	vy0line.text = ""
	
	t1line.text = ""
	t2line.text = ""
	t3line.text = ""

func reset():
	simulation = false
	
	a = 0
	b = 0
	c = 0
	d = 0
	
	accelx = a
	accely = c
	
	vx0 = 0
	vy0 = 0
	
	t1 = 0
	t2 = 0
	t3 = 0
	
	ball.position = Vector2(0 ,0)
	
	clear()

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_start_pressed():
	read()
	v = sqrt(vx**2 + vy**2)
	t = 0
	x = 0
	y = 0
	simulation = true

func _on_stop_pressed():
	simulation = false

func _on_reset_pressed():
	simulation = false
	reset()
	clear()
	update_tiles()

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

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
