extends Node2D

var controller_id : int = 0

var force : float = 0.0 # 0 - 1
var angle : float = 0.0 # radians
var lift_angle : float = 0.0 # radians

var max_lift_angle : float = PI / 4.5
var force_mult : float = 1000.0
var max_angle : float = PI / 2.5

var onion_preload = preload("res://Offense/Onion.tscn")
var onion_distance = 7
onready var onions = []

func _ready():
	create_onions(5)
	
func _process(_delta):
	var left_joy_x = -Input.get_joy_axis(controller_id, 0)
	var right_joy_y = Input.get_joy_axis(controller_id, 3)
	angle = left_joy_x * max_angle
	lift_angle = ((right_joy_y + 1) / 2) * max_lift_angle
	
	for onion in onions:
		var onion_index = onions.find(onion)
		onion.modulate.a = (float(onion_index + 1) / 5.0) * force
		var onion_length = -onion_distance * force * (len(onions) - onion_index)
		onion.position.y = onion_length * cos(angle) * cos(lift_angle)
		onion.position.x = onion_length * sin(angle) * cos(lift_angle)
		# var lift_angle_onion = lift_angle * sqrt(len(onions) - onion_index - 0.6) * 12
		onions[onion_index].get_node('Point').position.y = sin(lift_angle) * onion_length
		onions[onion_index].get_node('Shadow').modulate.a = lift_angle * (onion_index + 1) / 10
		# https://media.giphy.com/media/G7PwL96y3pxl26eXmB/giphy.gif
		
func _input(event):
	if event.device == controller_id:
		force = Input.get_action_strength("Force")
		if event.is_action_pressed("Kick"):
			var velocity = (force * force_mult)
			get_parent().get_node("Ball").move(
				-velocity * cos(lift_angle) * sin(angle), # X
				-velocity * cos(lift_angle) * cos(angle), # Y
				velocity * sin(lift_angle) / 6 # Z
			)
	
func create_onions(amt : int):
	for onion in amt:
		var onion_instance = onion_preload.instance()
		$OnionLine.add_child(onion_instance)
		onions.append(onion_instance)





