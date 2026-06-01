extends Node2D

@onready var submarine = $submarine

@onready var ro1line = $interface/ColorRect/MarginContainer/HBoxContainer/input/first/ro1line
@onready var vline = $interface/ColorRect/MarginContainer/HBoxContainer/input2/f/vline

@onready var ro2value = $interface/ColorRect/MarginContainer/HBoxContainer/input/second/ro2label

@onready var status = $interface/ColorRect/MarginContainer/HBoxContainer/input2/f2/status

@onready var path = $Path2D/PathFollow2D
var mark_tween : Tween = null
var mark_y : float

var swim_tween : Tween = null

var simulation : bool = false

var ro1 : float
var ro2 : float
var v
var status_text : String

var target_depth : float = 300.0 
const SMOOTH_SPEED = 2.0 

const BASE_SPEED = 80.0 #v = 10, |ro2 - ro1| = 1
const REF_VOLUME = 10.0  #basic volume
const MAX_SPEED = 300.0 
const MIN_DIFF = 0.01 #минимальная разница плотностей


func _ready():
	simulation = false
	status.text = "(...)"
	swim(submarine)

func _process(delta):
	if !simulation:
		return
	
	get_ro2()
	
	#var base_depth: float
	#match ro2:
		#10.0: base_depth = 120
		#20.0: base_depth = 170
		#30.0: base_depth = 220
		#40.0: base_depth = 270
		#50.0: base_depth = 320
		#60.0: base_depth = 370
		#70.0: base_depth = 420
		#_: pass
	
	var ratio = 1.0
	var speed = 0.0
	
	if ro1 != 0:
		ratio = ro2 / ro1
		var diff = abs(ratio - 1.0)
		
		if diff < MIN_DIFF:
			status_text = "Дрейфует"
			speed = 0.0
		elif ratio > 1.0:
			status_text = "Тонет"
			speed = BASE_SPEED * (v / REF_VOLUME) * (ratio - 1.0)
			speed = clamp(speed, 0.0, MAX_SPEED)
			
			var new_y = move_toward(submarine.position.y, 420, speed * delta)
			submarine.position.y = new_y
		else:
			status_text = "Всплывает"
			speed = BASE_SPEED * (v / REF_VOLUME) * (1.0 - ratio)
			speed = clamp(speed, 0.0, MAX_SPEED)
			
			var new_y = move_toward(submarine.position.y, 120, speed * delta)
			submarine.position.y = new_y

	else:
		status_text = "ВОДА?!"
	
	#target_depth = clamp(base_depth * ratio, 120.0, 420.0)
	#var new_y = move_toward(submarine.position.y, target_depth, SMOOTH_SPEED * 100 * delta)
	#submarine.position.y = new_y
	
	write()

func swim(body):
	if swim_tween:
		swim_tween.kill()
	
	swim_tween = create_tween()
	swim_tween.set_loops()
	
	var start_a = body.rotation
	
	swim_tween.tween_property(body, "rotation", start_a + PI/16, 0.3).set_ease(Tween.EASE_IN_OUT)
	swim_tween.tween_property(body, "rotation", start_a, 0.3).set_ease(Tween.EASE_IN_OUT)
	swim_tween.tween_property(body, "rotation", start_a - PI/16, 0.3).set_ease(Tween.EASE_IN_OUT)
	swim_tween.tween_property(body, "rotation", start_a, 0.3).set_ease(Tween.EASE_IN_OUT)

func scale(body):
	read()
	var scale_factor = v / 10.0
	scale_factor = clamp(scale_factor, 0.2, 7.0)
	body.scale = Vector2(scale_factor, scale_factor)

func start_mark():
	if mark_tween:
		mark_tween.kill()
		mark_tween = null
	
	mark_tween = create_tween()
	mark_tween.tween_property(path, "progress_ratio", 1.0, 15.0)
	
	if !simulation:
		mark_tween.pause()

#[44.0, 70.0, 80.0, 95.0, 123.0, 135.0, 150.0]
func get_ro2():
	var point : Vector2 = $Path2D.curve.sample_baked(path.progress)
	mark_y = point.y
	match mark_y:
		44.0: ro2 = 70 #y = 156
		70.0: ro2 = 60 #y = 206
		80.0: ro2 = 50 #y = 256
		95.0: ro2 = 40 #y = 306
		123.0: ro2 = 30 #y = 356
		135.0: ro2 = 20 #y = 406
		150.0: ro2 = 10 #y = 456
		_: pass

func read():
	ro1 = get_lines(ro1line)
	v = get_lines(vline)

func write():
	ro2value.text = str(snapped(ro2, 0.1))
	status.text = status_text

func get_lines(line_edit: LineEdit, default: float = 0.0) -> float:
	if line_edit.text.is_valid_float():
		return float(line_edit.text)
	return default

func _on_start_pressed():
	read()
	scale(submarine)
	simulation = true
	start_mark()

func _on_stop_pressed():
	simulation = false
	mark_tween.pause()

func _on_reset_pressed():
	simulation = false
	ro1 = 0
	ro2 = 0
	v = 0
	status.text = "(...)"
	path.progress = 0.0
	submarine.position.y = 300

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
