extends Node2D

var enter_speed : Vector2
var inside_speed : Vector2
var exit_speed : Vector2

@export var n1 : float = 1.0
@export var n2 : float = 1.0

var alpha: float
var beta: float

var sina : float
var sinb : float

var vmod : float

@onready var numberline = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/number
var number
@onready var vbox = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer
@onready var set_button = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/set

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass
	

func read():
	number = int(numberline.text)

func _on_area_2d_body_entered(body):
	if body.name == "light":
		
		enter_speed = body.linear_velocity
		
		vmod = sqrt(enter_speed.x ** 2 + enter_speed.y ** 2)
		
		sina = enter_speed.x / vmod
		sinb = sina * n1/n2
		
		print("sina = ", sina)
		print("sinb = ", sinb)
		
		inside_speed.x = sinb * vmod
		inside_speed.y = sqrt(1 - sinb**2) * vmod
		
		print("inside ", inside_speed)
		
		body.linear_velocity = inside_speed


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
		slot_instance.add_to_group("slots")
		slot_instance.add_child(slot_label)
		slot_instance.add_child(slot_line)
		vbox.add_child(slot_instance)
		new_slots.append(slot_instance)
		
		var target_index = set_button.get_index()
		for j in range(new_slots.size() - 1, -1, -1):
			vbox.move_child(new_slots[j], target_index)
