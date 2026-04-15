extends Node3D

@onready var info = $info
@onready var ball = $ball

var speedXLine
var speedYLine
var speedZLine
var accelLine

var speedLabel
var speedXLabel
var speedYLabel
var speedZLabel
var distLabel
var xLabel
var yLabel
var zLabel

var speed: float = 0.0
var speedX: float = 0.0
var speedY: float = 0.0
var speedZ: float = 0.0
var accel: float = 0.0
var distance: float = 0.0
var x: float = 0.0
var y: float = 0.0
var z: float = 0.0
var azim: float = 0.0
var elev: float = 0.0

func _ready():
	Engine.time_scale = 0
	
	info.reset_pressed.connect(reset)
	info.start_pressed.connect(start)
	info.stop_pressed.connect(stop)
	
	speedXLine = info.find_child("speedXLine", true, false)
	speedYLine = info.find_child("speedYLine", true, false)
	speedZLine = info.find_child("speedZLine", true, false)
	
	accelLine = info.find_child("accelLine", true, false)
	
	speedLabel = info.find_child("speedValue", true, false)
	speedXLabel = info.find_child("speedXValue", true, false)
	speedYLabel = info.find_child("speedYValue", true, false)
	speedZLabel = info.find_child("speedZValue", true, false)
	
	distLabel = info.find_child("distValue", true, false)
	
	xLabel = info.find_child("xValue", true, false)
	yLabel = info.find_child("yValue", true, false)
	zLabel = info.find_child("zValue", true, false)
	
	ball.position = Vector3(0, 0, 0)
	
	if speedXLine.text != "":
		speedX = float(speedXLine.text)
	else: speedX = 0
	if speedYLine.text != "":
		speedY = float(speedYLine.text)
	else: speedY = 0
	if speedZLine.text != "":
		speedZ = float(speedZLine.text)
	else: speedZ = 0
	
	speed = sqrt(speedX**2 + speedY**2 + speedZ**2)
	
	azim = atan2(speedZ, speedX)
	elev = atan2(speedY, sqrt(speedX**2 + speedZ**2))
	
	write()
	
	print("speedXLine: ", speedXLine)
	print("speedLabel: ", speedLabel)
	print("xLabel: ", xLabel)

func _process(delta):
	ball.position = Vector3(x, y, z)
	distance = sqrt(x**2 + y**2 + z**2)
	
	if speed != 0:
		x += speedX * delta
		y += speedY * delta
		z += speedZ * delta
	
	if accel != 0:
		speed += accel * delta
		
		speedX = speed * cos(elev) * cos(azim)
		speedY = speed* sin(elev)
		speedZ = speed * cos(elev) * sin(azim)
	
	write()

func reset():
	speed = 0
	speedX = 0
	speedY = 0
	speedZ = 0
	accel = 0
	x = 0
	y = 0
	z = 0
	azim = 0
	elev = 0
	ball.position = Vector3(x, y, z)
	
	
	
	write()

func write():
	xLabel.text = str(snapped(x, 0.01))
	yLabel.text = str(snapped(y, 0.01))
	zLabel.text = str(snapped(z, 0.01))
	
	speedXLabel.text = str(snapped(speedX, 0.01))
	speedYLabel.text = str(snapped(speedY, 0.01))
	speedZLabel.text = str(snapped(speedZ, 0.01))
	speedLabel.text = str(snapped(speed, 0.01))
	
	distLabel.text = str(snapped(distance, 0.01))

func start():
	Engine.time_scale = 1
	
	if speedXLine.text != "":
		speedX = float(speedXLine.text)
	else: speedX = 0
	if speedYLine.text != "":
		speedY = float(speedYLine.text)
	else: speedY = 0
	if speedZLine.text != "":
		speedZ = float(speedZLine.text)
	else: speedZ = 0
	if accelLine.text != "":
		accel = float(accelLine.text)
	else: accel = 0
	
	speed = sqrt(speedX**2 + speedY**2 + speedZ**2)
	
	azim = atan2(speedZ, speedX)
	elev = atan2(speedY, sqrt(speedX**2 + speedZ**2))
	
	ball.position = Vector3(x, y, z)

func stop():
	Engine.time_scale = 0
