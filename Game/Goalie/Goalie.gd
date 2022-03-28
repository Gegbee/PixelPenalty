extends Node2D

var controller_id : int = 1

var DIVE_RANGE : int = 550
var MOVE_SPEED : int = 120
var MAX_DIVE_RANGE : int = 18 * 6
var DIVE_SPEED = 3.5

var onion_preload = preload("res://Game/Kicker/Onion.tscn")
var onion_distance : float = 6
onready var onions = []

var right_joy_x = 0
var left_joy_x = 0
var left_joy_y = 0
var dive_vel = 0
var target_position := Vector2()
var start_position := Vector2()

var time : float = 0.0

enum {
	MOVING,
	DIVING,
	GROUNDED,
	FALLING
}

var state := MOVING

func _ready():
	create_onions(3)
	
func _physics_process(delta):
		
	if state == MOVING:
		right_joy_x = Input.get_joy_axis(controller_id, 2)
		left_joy_x = Input.get_joy_axis(controller_id, 0)
		left_joy_y = Input.get_joy_axis(controller_id, 1)
		left_joy_y = clamp(left_joy_y, -1, 0)
		if abs(right_joy_x) < 0.1:
			right_joy_x = 0 
		dive_vel = Vector2(left_joy_x, left_joy_y)
		if dive_vel.length() < 0.1:
			dive_vel = Vector2()
		position += Vector2(right_joy_x * MOVE_SPEED, 0) * delta
		
		for onion in onions:
			var onion_index = onions.find(onion)
			onion.modulate.a = (float(onion_index + 1) / len(onions)) * (dive_vel.length())
			onion.position = onion_distance * dive_vel * (len(onions) - onion_index)
			
	elif state == DIVING:
		time += delta
		position.y += dive_vel.y * DIVE_SPEED + 4 * time# -2 * target_position.y / target_position.x * (time/target_position.x - 1)
		position.x += dive_vel.x * DIVE_SPEED
		if abs(dive_vel.x) > 0.3 and dive_vel.y * DIVE_SPEED + 4 * time < 0:
			$Goalie.rotation = atan2(dive_vel.y * DIVE_SPEED + 4 * time, dive_vel.x * DIVE_SPEED) + PI/2
		# cos($Goalie.rotation * 2) * (left_joy_y * DIVE_RANGE + 100)
		# position += Vector2(dive_vel.x * MOVE_SPEED * 2.4, cos($Goalie.rotation * 2) * (left_joy_y * DIVE_RANGE)) * delta
		
		if position.y >= start_position.y:
			state = GROUNDED
			$Timer.start(0.5)
			
		for onion in onions:
			onion.modulate.a = 0
	elif state == FALLING:
		pass
	elif state == GROUNDED:
		pass
		
func _input(event):
	if event.device == controller_id:
		if event.is_action_pressed("Dive") and state != DIVING and state != GROUNDED:
			state = DIVING
			time = 0
			start_position = position
			target_position = dive_vel * MAX_DIVE_RANGE
			print(target_position)
#			var final_rotation = PI/2
#			if left_joy_x < 0:
#				final_rotation *= -1
#			$Tween.interpolate_property($Goalie, "rotation", $Goalie.rotation, $Goalie.rotation + final_rotation, dive_vel.length() /2, Tween.TRANS_CUBIC)
#			$Tween.start()
	
func create_onions(amt : int):
	for onion in amt:
		var onion_instance = onion_preload.instance()
		$OnionLine.add_child(onion_instance)
		onions.append(onion_instance)


func _on_Tween_tween_all_completed():
	state = GROUNDED
	$Timer.start(0.5)

func _on_Timer_timeout():
	state = MOVING
	$Goalie.rotation = 0
