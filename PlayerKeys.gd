extends Node

var xbox = "XInput Gamepad"

var p_one_key : int = -1
var p_two_key : int = -1

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id))
		if p_one_key != -1:
			p_one_key = 0
