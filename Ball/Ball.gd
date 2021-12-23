extends Node2D

var lift : float = 0.0
var init_velocity : float = 0.0
var velocity : float = 0.0
var angle : float = 0.0
var height : float = 0.0

var lift_mult : float = 4.8
var moving = false
var time : float = 0.0
var z_time : float = time
var xy_time : float = time
var init_pos = Vector2()

const GRAVITY = 50.0
const MASS : int = 2
const FRICTION_COEFFICIENT : float = 260.0
const AIR_RESISTANCE_COEFFICIENT : float = 70.0

func _ready():
	init_pos = position
	$Shadow.modulate.a = 0.4
	get_parent().get_node("Debug").add_debug_label("height")
	
func _process(delta):
	if moving:
		$Ball/BallSprite.speed_scale = velocity / 120
		$Ball/BallSprite.play('rolling')
		time += delta
		z_time += delta
		xy_time += delta
		height = sin(lift) * init_velocity * z_time / lift_mult - GRAVITY * 0.5 * pow(z_time, 2)
		get_parent().get_node("Debug").update_debug_label("height", str(height))
		if height < 0:
			lift_mult *= 1.9
			z_time = 0
		$Ball.position.y = -height
		position.x -= sin(angle) * cos(lift) * velocity * delta
		position.y -= cos(angle) * cos(lift) * velocity * delta
		if velocity <= 0:
			xy_time = 0
			velocity = 0
		else:
			if height < 0.5:
				var friction = delta * FRICTION_COEFFICIENT
				velocity = velocity - friction
			else:
				var air_resistance = delta * AIR_RESISTANCE_COEFFICIENT 
				velocity = velocity - air_resistance
	else:
		$Ball/BallSprite.play('default')
		
func kick(_init_velocity : float, _lift : float, _angle : float):
	lift = _lift
	init_velocity = _init_velocity
	velocity = _init_velocity
	angle = _angle
	moving = true


func _on_Ball_body_entered(body):
	moving = false
