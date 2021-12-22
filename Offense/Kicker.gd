extends Node2D

var controller_id : int = 0

var force : float = 0.0 # 0 - 1
var angle : float = 0.0 # radians
var lift : float = 0.0 # radians

var max_lift : float = PI / 6
var force_mult : float = 1500.0
var max_angle : float = PI / 3

const MASS : float = 2.0

onready var onions = [$OnionLine/line, $OnionLine/line2, $OnionLine/line3, $OnionLine/line4, $OnionLine/line5]
onready var shadows = [$OnionLine/shadow, $OnionLine/shadow2, $OnionLine/shadow3, $OnionLine/shadow4, $OnionLine/shadow5]

func _process(_delta):
	var left_joy_x = -Input.get_joy_axis(controller_id, 0)
	var right_joy_y = Input.get_joy_axis(controller_id, 3)
	angle = left_joy_x * max_angle
	lift = ((right_joy_y + 1) / 2) * max_lift
	
	for onion in onions:
		var onion_index = onions.find(onion)
		onion.modulate.a = (float(onion_index + 1) / 5.0) * force
		var onion_length = -7 * force * (len(onions) - onion_index)
		onion.position.y = onion_length * cos(angle) * cos(lift)
		onion.position.x = onion_length * sin(angle) * cos(lift)
		shadows[onion_index].position = onion.position
		# var lift_onion = lift * sqrt(len(onions) - onion_index - 0.6) * 12
		onion.position.y += sin(lift) * onion_length
		shadows[onion_index].modulate.a = lift * (onion_index + 1) / 10
		# https://media.giphy.com/media/G7PwL96y3pxl26eXmB/giphy.gif
		
func _input(event):
	if event.device == controller_id:
		force = Input.get_action_strength("Force")
		if event.is_action_pressed("Kick"):
			var velocity = (force * force_mult) / MASS
			get_parent().get_node("Ball").kick(velocity, lift, angle)
