extends Node2D

@onready var s1line = $interface/ColorRect/MarginContainer/HBoxContainer/input/first/s1line
@onready var s2line = $interface/ColorRect/MarginContainer/HBoxContainer/input/second/s2line

@onready var fline = $interface/ColorRect/MarginContainer/HBoxContainer/input2/f/fline
@onready var mline = $interface/ColorRect/MarginContainer/HBoxContainer/input2/m/mline

@onready var pump1 = $pump1
@onready var pump2 = $pump2
@onready var pipe = $pipe
@onready var mass = $mass
@onready var force = $force

var s1
var s2
var f
var m

var f1
var f2

const G = 9.8

func _ready():
	pass


func _process(_delta):
	pass

func read():
	s1 = get_lines(s1line)
	s2 = get_lines(s2line)
	m = get_lines(mline)
	f = get_lines(fline)

func write():
	pass

func set_pump(pump: ColorRect, s: float):
	pump.size.x = s
	var water = pump.get_node("water")
	water.size.x = s
	water.size.y = 100
	
	water.position.y = pump.size.y - water.size.y
	water.position.x = 0
	
	set_forces()

func set_forces():
	var mass_pump 
	var force_pump
	if s1 > s2:
		mass_pump = pump1
		force_pump = pump2
	else:
		mass_pump = pump2
		force_pump = pump1
	
	var mass_water = mass_pump.get_node("water")
	
	mass.position.y = mass_water.position.y + mass_water.size.y + 20
	mass.position.x = mass_pump.position.x + 0.5* (mass_pump.size.x - mass.size.x)
	
	force.position.y = 160
	force.position.x = force_pump.position.x + 0.5* (force_pump.size.x - force.size.x)

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_set_pressed():
	read()
	set_pump(pump1, s1)
	set_pump(pump2, s2)
	
	var left_bottom = pump1.position + Vector2(0, pump1.size.y)
	var right_bottom = pump2.position + Vector2(pump2.size.x, pump2.size.y)
	
	pipe.size.x = right_bottom.x - left_bottom.x
	pipe.position = Vector2(left_bottom.x, left_bottom.y - pipe.size.y)


func _on_reset_pressed():
	s1line.text = str(10)
	s2line.text = str(10)
	_on_set_pressed()


func _on_start_pressed():
	read()
	print("F = ", f)
	print("m = ", m)
	#f2/f1 = s2/s1
	# f1 = f
	# f2 - выталкивает
	# if f2 > mg - mass goes up
	#elif f2 < mg - mass goes down
	#else nothing
	# f2 = s2/s1 * f1
	
	f1 = f
	
	if s1 > s2:
		f2 = f1 * (s1 / s2)
	else:
		f2 = f1 * (s2 / s1)
	
	if f2 > m * G:
		go_up()
	elif f2 < m * G:
		go_down()
	else:
		pass
	

func go_up():
	var mass_pump 
	if s1 > s2:
		mass_pump = pump1
	else:
		mass_pump = pump2
	
	var mass_water = mass_pump.get_node("water")
	
	mass_water.size.y += 20
	mass_water.position.y -= 20
	
	mass.position.y -= 20

func go_down():
	var mass_pump 
	if s1 > s2:
		mass_pump = pump1
	else:
		mass_pump = pump2
	
	var mass_water = mass_pump.get_node("water")
	
	mass_water.size.y -= 20
	mass_water.position.y += 20
	
	mass.position.y += 20

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
