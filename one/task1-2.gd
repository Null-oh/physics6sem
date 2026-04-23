extends Node2D

@onready var ball = $ball
@onready var tiles = $"2dTiles"
@onready var screen_size = get_viewport().get_visible_rect().size

@onready var vxline = $info2d/back/MarginContainer/HBoxContainer/speed/Vx/Vxvalue
@onready var vyline = $info2d/back/MarginContainer/HBoxContainer/speed/Vy/Vyvalue
@onready var axline = $info2d/back/MarginContainer/HBoxContainer/accel/Ax/Axvalue
@onready var ayline = $info2d/back/MarginContainer/HBoxContainer/accel/Ay/Ayvalue

@onready var xvalue = $info2d/back/MarginContainer/HBoxContainer/current/curX/xvalue
@onready var yvalue = $info2d/back/MarginContainer/HBoxContainer/current/curY/yvalue
@onready var vvalue = $info2d/back/MarginContainer/HBoxContainer/current/totalV/Vvalue
@onready var alphavalue = $info2d/back/MarginContainer/HBoxContainer/speed/alpha/alphaValue
@onready var zerovalue = $info2d/back/MarginContainer/HBoxContainer/accel/zero/zerovalue
@onready var svalue = $info2d/back/MarginContainer/HBoxContainer/current2/S/Svalue
@onready var tvalue = $info2d/back/MarginContainer/HBoxContainer/current2/T/Tvalue

var x : float
var y : float

var vx : float
var vy  : float
var v : float

var ax : float
var ay : float
var a : float

var alpha : float

var s : float
var sabs : float
var zero : float
var t : float

var simulating : bool = false

func _ready():
	read()
	update_ders()
	ball.position = Vector2(x, - y)
	
	write()

func _process(delta):
	if not simulating: return
	
	x += vx * delta
	y += vy * delta
	vx += ax * delta
	vy += ay * delta
	t += delta
	
	sabs = sqrt(vx**2 + vy**2)
	s += sabs * delta
	
	update_ders()
	ball.position = Vector2(x ,-y)
	update_tiles()
	write()

func read():
	vx = get_lines(vxline)
	vy = get_lines(vyline)
	ax = get_lines(axline)
	ay = get_lines(ayline)

func update_ders():
	v = sqrt(vx**2 + vy**2)
	alpha = atan2(vy, vx)

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func reset():
	simulating = false
	t = 0
	v = 0
	vx = 0
	vy = 0
	ax = 0
	ay = 0
	x = 0
	y = 0
	s = 0
	sabs = 0
	alpha = 0
	ball.position = Vector2(0, 0)
	update_tiles()
	write()

func write():
	xvalue.text = str(snapped(x, 0.01))
	yvalue.text = str(snapped(y, 0.01))
	
	v = sqrt(vx**2 + vy**2)
	vvalue.text = str(snapped(v, 0.01))
	
	alpha = atan2(vy, vx)
	alphavalue.text = str(snapped(alpha, 0.01))
	
	svalue.text = str(snapped(s, 0.01))
	tvalue.text = str(snapped(t, 1))
	
	vxline.text = str(snapped(vx, 0.01))
	vyline.text = str(snapped(vy, 0.01))

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

func _on_stop_pressed():
	simulating = false

func _on_go_pressed():
	read()
	update_ders()
	t = 0
	x = 0
	y = 0
	simulating = true

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

func _on_reset_pressed():
	reset()
