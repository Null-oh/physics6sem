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


func _on_fiveone_pressed() -> void:
	get_tree().change_scene_to_file("res://five/five-one.tscn")


func _on_six_pressed() -> void:
	get_tree().change_scene_to_file("res://six/six_one.tscn")


func _on_eight_pressed():
	get_tree().change_scene_to_file("res://eight/eight_one.tscn")


func _on_ten_pressed():
	get_tree().change_scene_to_file("res://ten/ten-one.tscn")


func _on_tentwo_pressed():
	get_tree().change_scene_to_file("res://ten/ten_two.tscn")


func _on_tenthree_pressed():
	get_tree().change_scene_to_file("res://ten/ten_three.tscn")


func _on_eightthree_pressed():
	get_tree().change_scene_to_file("res://eight/eight-three.tscn")
