extends Node2D



func _on_task_1_pressed():
	get_tree().change_scene_to_file("res://one/task_1_2.tscn")


func _on_task_2_pressed():
	get_tree().change_scene_to_file("res://task_2.tscn")


func _on_three_pressed():
	get_tree().change_scene_to_file("res://three/three.tscn")


func _on_fourone_pressed():
	get_tree().change_scene_to_file("res://four/four_one_two.tscn")


func _on_fourtwo_pressed():
	get_tree().change_scene_to_file("res://four/four-two.tscn")
