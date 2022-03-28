extends Node2D


func _process(_delta):
	if Input.is_action_just_pressed('Exit'):
		get_tree().quit()
	if Input.is_action_just_pressed('Reset'):
		var _new_scene = get_tree().reload_current_scene()
