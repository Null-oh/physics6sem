extends Node3D

@onready var ball = $ball
@onready var camera = $Camera3D

@onready var vline = $info/ColorRect/MarginContainer/HBoxContainer/input/v/vvalue
@onready var t1line = $info/ColorRect/MarginContainer/HBoxContainer/input/t1/t1value
@onready var aline = $info/ColorRect/MarginContainer/HBoxContainer/input2/a/avalue
@onready var bline = $info/ColorRect/MarginContainer/HBoxContainer/input2/b/bvalue
@onready var rline = $info/ColorRect/MarginContainer/HBoxContainer/input/r/rvalue

@onready var xvalue = $info/ColorRect/MarginContainer/HBoxContainer/current/curX/xvalue
@onready var yvalue = $info/ColorRect/MarginContainer/HBoxContainer/current/curY/yvalue
@onready var zvalue = $info/ColorRect/MarginContainer/HBoxContainer/current/curZ/zvalue
@onready var tvalue = $info/ColorRect/MarginContainer/HBoxContainer/VBoxContainer2/t/tvalue
@onready var svalue = $info/ColorRect/MarginContainer/HBoxContainer/current/S/svalue
@onready var accelvalue = $info/ColorRect/MarginContainer/HBoxContainer/input2/accel/accelvalue
@onready var alphavalue = $info/ColorRect/MarginContainer/HBoxContainer/input2/alpha/alphavalue

var v : float
var t1 : float
var r : float
var a : float
var b : float

var x : float
var y : float #vertical
var z : float
var t : float
var s : float
var accel : float

var alpha : float

var simulation : bool = false

var cam_position = Vector3(20, 15, 20)

func _ready():
	read()
	ball.position = Vector3(r, 0, 0)
	write()

func _process(delta):
	if !simulation: return
	
	if t <= t1:
		t += delta
		
		if a != 0 and b != 0:
			accel = a + b * t
			v += accel * delta
			camera.position = cam_position + Vector3(0, y, 0)
		
		y = v * t
		
		#s = vt
		#v = sqrt(v**2 + vy**2)
		#s = sqrt( (omega*r)**2 + vy**2) ) * t
		# = sqrt( r**2 + v**2 ) * t
		
		s = sqrt(r**2 + v**2) * t
		
		x = r * cos(t)
		z = r * sin(t)
		
		alpha = rad_to_deg(atan2(z, x))
		
		ball.position = Vector3(x, y, z)
		
		write()

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func write():
	xvalue.text = str(snapped(x, 0.01))
	yvalue.text = str(snapped(y, 0.01))
	zvalue.text = str(snapped(z, 0.01))
	tvalue.text = str(snapped(t, 0.1))
	svalue.text = str(snapped(s, 0.01))
	accelvalue.text = str(snapped(accel, 0.01))
	alphavalue.text = str(snapped(alpha, 0.01))

func read():
	v = get_lines(vline)
	t1 = get_lines(t1line)
	a = get_lines(aline)
	b = get_lines(bline)
	r = get_lines(rline)

func reset():
	simulation = false
	ball.position = Vector3(0, 0, 0)
	camera.position = cam_position
	
	t = 0
	v = 0
	t1 = 0
	r = 0
	a = 0
	b = 0
	x = 0
	y = 0
	z = 0
	s = 0
	accel = 0
	write()


func _on_go_pressed():
	read()
	simulation = true


func _on_reset_pressed():
	simulation = false
	reset()
	write()


func _on_stop_pressed():
	simulation = false


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
