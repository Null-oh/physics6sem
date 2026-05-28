extends Node2D

@onready var alphaline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/alpha/alphaline
@onready var sline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/s/sline
@onready var nline = $CanvasLayer/ColorRect/MarginContainer/HBoxContainer/input1/n/nline

@onready var lense1 = $lense1

var alpha
var s
var n


func _ready():
	lense1.size.x = s


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func read():
	pass

func write(): 
	pass
