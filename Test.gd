extends Node2D


func _process(_delta):
	if Input.is_action_just_pressed('escape'):
		get_tree().quit()
	if Input.is_action_just_pressed('enter'):
		var new_scene = get_tree().reload_current_scene()
