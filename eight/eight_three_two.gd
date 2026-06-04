extends Node2D

@onready var vbox = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer
var number: int
@onready var numberline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/number

@onready var set_button = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/set

@export var zone_top : float = 175.0
@export var zone_bottom : float = 600.0
@onready var areas = $areas

@onready var light = $light
@export var vx : float = 100.0
@export var vy : float = 100.0

@export var C : float = 100.0

@onready var alphaline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/alphaline
var alpha : float

var current_n : float = 1.0

@onready var lines = $lines
var current_line : Line2D = null
const COLOUR = Color.RED
var is_moving: bool = false

func _ready():
	_on_reset_pressed()
	_on_clear_pressed()
	
	current_n = 1.0
	
	if not lines:
		lines = Node2D.new()
		lines.name = "lines"
		add_child(lines)

func _physics_process(_delta):
	
	if is_moving and light.position.y >= 900:
		point()
		is_moving = false
		current_line = null
		return
	
	var new_n = 1.0
	
	for area in areas.get_children():
		if area is Area2D and area.overlaps_body(light):
			new_n = area.get_meta("refractive_index")
			break
	
	if new_n != current_n:
		
		point()
		draw()
		
		var v = light.linear_velocity
		var vmod = v.length()
		
		if vmod > 0:
			var sina = v.x / vmod
			var sinb = sina * current_n / new_n
			
			if abs(sinb) > 1:
				light.linear_velocity = Vector2(v.x, -v.y)
			else:
				var new_vx = sinb * vmod
				var new_vy = sign(v.y) * sqrt(1 - sinb*sinb) * vmod
				light.linear_velocity = Vector2(new_vx, new_vy)
				current_n = new_n 
	

func read():
	number = int(numberline.text)

func write(): 
	pass

func draw():
	var line = Line2D.new()
	line.default_color = COLOUR
	line.width = 3
	line.antialiased = true
	lines.add_child(line)
	current_line = line
	current_line.add_point(light.position)

func point():
	if not current_line:
		return
	
	var last_point = current_line.get_point_position(current_line.get_point_count() - 1) if current_line.get_point_count() > 0 else null
	if last_point == null or last_point.distance_to(light.position) > 0.1:
		current_line.add_point(light.position)

func _on_make_pressed():
	read()
	for child in vbox.get_children():
		if child.is_in_group("slots"):
			child.queue_free()
	
	var new_slots = []
	
	for i in number:
		var slot_instance = HBoxContainer.new()
		
		var slot_label = Label.new()
		slot_label.text = "ni = "
		
		var slot_line = LineEdit.new()
		slot_line.add_to_group("datas")
		
		slot_instance.add_to_group("slots")
		slot_instance.add_child(slot_label)
		slot_instance.add_child(slot_line)
		
		vbox.add_child(slot_instance)
		new_slots.append(slot_instance)
		
		var target_index = set_button.get_index()
		for j in range(new_slots.size() - 1, -1, -1):
			vbox.move_child(new_slots[j], target_index)

func _on_set_pressed():
	var datas = get_tree().get_nodes_in_group("datas")
	var indices = []
	
	for data in datas:
		var text = data.text.strip_edges()
		if text.is_empty():
			return
		
		var n = float(text)
		if n <= 0:
			return
		
		indices.append(n)
	
	for area in get_tree().get_nodes_in_group("areas"):
		area.queue_free()
	
	var gap = zone_bottom - zone_top
	var area_height = gap / indices.size()
	var start_y = zone_top
	
	for i in range(indices.size()):
		
		var n = indices[i]
		var area = Area2D.new()
		area.add_to_group("areas")
		
		var collider = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		
		#var screen_size = get_viewport().get_visible_rect().size
		shape.extents = Vector2(1500, area_height / 2)
		collider.shape = shape
		area.add_child(collider)
		
		area.set_meta("refractive_index", n)
		
		var color_rect = ColorRect.new()
		color_rect.size = Vector2(3000, area_height)
		color_rect.position = Vector2(-1500, -area_height / 2)
		color_rect.color = Color(randf(), randf(), randf(), 0.4)
		area.add_child(color_rect)
		
		area.position = Vector2(0, start_y + area_height / 2)
		areas.add_child(area)
		start_y += area_height

func _on_clear_pressed():
	for child in vbox.get_children():
		if child.is_in_group("slots"):
			child.queue_free()
	
	for area in get_tree().get_nodes_in_group("areas"):
		area.queue_free()
	
	if lines:
		for child in lines.get_children():
			child.queue_free()
	current_line = null

func _on_start_pressed():
	if lines:
		for child in lines.get_children():
			child.queue_free()
	current_line = null
	is_moving = true
	
	alpha = deg_to_rad(float(alphaline.text))
	vx = sin(alpha) * C
	vy = cos(alpha) * C
	
	light.linear_velocity = Vector2(vx, vy)
	
	current_n = 1.0
	
	draw()


func _on_reset_pressed():
	light.set_deferred("position", Vector2(650, 20))
	light.linear_velocity = Vector2.ZERO
	
	if lines:
		for child in lines.get_children():
			child.queue_free()
	current_line = null


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://start.tscn")
