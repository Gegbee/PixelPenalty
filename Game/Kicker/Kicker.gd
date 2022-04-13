extends Node2D

var controller_id : int = 0

var one_kick := true
var kicked := false

var force : float = 0.0 # 0 - 1
var angle : float = 0.0 # radians
var lift_angle : float = 0.0 # radians

var max_lift_angle : float = PI / 4.5
var force_mult : float = 1000.0
var max_angle : float = PI / 2.5

var onion_preload = preload("res://Game/Kicker/Onion.tscn")
var onion_distance = 7
onready var onions = []
var final_force := 0.0
onready var animated_sprite = $Sprite/AnimatedSprite
onready var animated_shadow = $Sprite/AnimatedShadow

#x: 951.056516 y: -309.016994 z: 0
#x: -951.056516 y: -309.016994 z: 0
#x: -536.713699 y: -843.764425 z: 0
#x: 537.439974 y: -843.302006 z: 0
#x: 728.551559 y: -236.720751 z: 107.131268
#x: -728.551559 y: -236.720751 z: 107.131268
#x: 24.556079 y: -765.650761 z: 107.131268
#x: 13.307715 y: -765.928844 z: 107.131268
#x: 17.371989 y: -999.849096 z: 0
#x: 17.371989 y: -999.849096 z: 0

func _ready():
	animated_sprite.play('Idle')
	animated_shadow.play('Idle')
	create_onions(5)
	randomize()
	
func _process(_delta):
	var left_joy_x = -Input.get_joy_axis(controller_id, 0)
	var right_joy_y = Input.get_joy_axis(controller_id, 3)
	angle = left_joy_x * max_angle
	lift_angle = ((right_joy_y + 1) / 2) * max_lift_angle
	
	for onion in onions:
		var onion_index = onions.find(onion)
		onion.modulate.a = (float(onion_index + 1) / len(onions)) * force
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
			if !one_kick or !kicked:
				kicked = true
				final_force = Input.get_action_strength("Force")
				animated_sprite.play('Kick')
				animated_shadow.play('Kick')
				$AnimationPlayer.play("Kick")
				$KickTimer.start(0.1)
	
func create_onions(amt : int):
	for onion in amt:
		var onion_instance = onion_preload.instance()
		$OnionLine.add_child(onion_instance)
		onions.append(onion_instance)

func _on_KickTimer_timeout():
	kick(final_force, angle, lift_angle)
	# randomKick(0.1)

func _on_AnimatedSprite_animation_finished():
	if animated_sprite.animation == 'Kick':
		animated_sprite.play('Idle')
		animated_shadow.play('Idle')

func kick(_force, _angle, _lift_angle):
	var velocity = (_force * force_mult)
	$Kick.pitch_scale = 0.6 + (randf() * 0.2 - 0.1)
	$Kick.volume_db = 0 + force * 20
	$Kick.play()
	get_parent().get_node("Ball").move(
		-velocity * cos(_lift_angle) * sin(_angle), # X
		-velocity * cos(_lift_angle) * cos(_angle), # Y
		velocity * sin(_lift_angle) / 6 # Z
	)
#	print(
#		" x: ", -velocity * cos(_lift_angle) * sin(_angle), # X
#		" y: ", -velocity * cos(_lift_angle) * cos(_angle), # Y
#		" z: ", velocity * sin(_lift_angle) / 6 # Z
#	)

func randomKick(difficulty: float):
	var angle_net_border = max_angle/1.7
	var lift_angle_net_border = max_lift_angle/6
	var _force : float = 0.0
	var _angle : float = 0.0
	var _lift_angle : float = 0.0
	if difficulty != 0:
		_force = rand_range(0.5 + difficulty / 2, 1)
		_angle = rand_range(
			difficulty * (max_angle - angle_net_border), 
			max_angle - angle_net_border
			) * sign(rand_range(-1, 1))
		_lift_angle = rand_range(
			difficulty * (max_lift_angle - lift_angle_net_border), 
			max_lift_angle - lift_angle_net_border
			)
	else:
		_force = rand_range(0, 1)
		_angle = rand_range(-max_angle, max_angle)
		_lift_angle = rand_range(0, max_lift_angle)
	kick(_force, _angle, _lift_angle)
	
func reset():
	$AnimationPlayer.play("Idle")
	kicked = false
	
func _on_AITimer_timeout():
	pass
#	reset()
#	get_parent().get_node("Ball").reset()
#	animated_sprite.play('Kick')
#	animated_shadow.play('Kick')
#	$AnimationPlayer.play("Kick")
#	$KickTimer.start(0.1)
