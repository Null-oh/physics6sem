extends Node2D

@onready var ball = $ball

@onready var speedXLine = $CanvasLayer/info/MarginContainer/HBoxContainer/basic/speedX/speedXValue
@onready var speedYLine = $CanvasLayer/info/MarginContainer/HBoxContainer/basic/speedY2/speedYValue
@onready var accelLine = $CanvasLayer/info/MarginContainer/HBoxContainer/basic/accel/accelValue

@onready var speedXLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/basic/speedX/speedX
@onready var speedYLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/basic/speedY2/speedY
@onready var xLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/coords/xcoord/xValue
@onready var yLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/coords/ycoord/yValue
@onready var speedLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/end/speed/speedValue
@onready var distanceLabel = $CanvasLayer/info/MarginContainer/HBoxContainer/coords/distance/distanceValue

var speedX
var speedY
var speed
var accel
var distance
var alpha
var x
var y

@onready var tiles = $"2dTiles"
@onready var screen_size = get_viewport().get_visible_rect().size

func _ready():
	Engine.time_scale = 0
	
	if speedXLine.text != null:
		speedX = float(speedXLine.text)
	else: speedX = 0
	if speedYLine.text != null:
		speedY = float(speedYLine.text)
	else: speedY = 0
	
	if accelLine.text != null:
		accel = float(accelLine.text)
	else: accel = 0
	
	speed = sqrt(speedX**2 + speedY**2)
	
	alpha = atan2(speedY, speedX)
	
	distance = 0
	x = 0
	y = 0
	
	ball.position = Vector2(x, y)
	
	write()


func _process(delta):
	write()
	
	ball.position = Vector2(x, -y)
	distance = sqrt(x**2 + y**2)
	
	if speed != 0:
		x += speedX * delta
		y += speedY * delta
	
	if accel != 0:
		speed += accel * delta
		
		speedX = speed * cos(alpha)
		speedY = speed * sin(alpha)
	
	update_tiles()

func write():
	xLabel.text = str(snapped(x, 0.01))
	yLabel.text = str(snapped(y, 0.01))
	if accel != 0:
		speedXLine.text = str(snapped(speedX, 0.01))
		speedYLine.text = str(snapped(speedY, 0.01))
	distanceLabel.text = str(snapped(distance, 0.01))
	speedLabel.text = str(snapped(speed, 0.01))

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")

func _on_reset_pressed():
	x = 0
	y = 0
	speedX = 0
	speedY = 0
	accel = 0
	ball.position = Vector2(x, y)
	write()

func _on_pause_pressed():
	Engine.time_scale = 0

func _on_go_pressed():
	Engine.time_scale = 1
	
	if speedXLine.text != null:
		speedX = float(speedXLine.text)
	else: speedX = 0
	if speedYLine.text != null:
		speedY = float(speedYLine.text)
	else: speedY = 0
	
	if accelLine.text != null:
		accel = float(accelLine.text)
	else: accel = 0
	
	speed = sqrt(speedX**2 + speedY**2)
	
	alpha = atan2(speedY, speedX)
	ball.position = Vector2(x, y)
	
	write()

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
