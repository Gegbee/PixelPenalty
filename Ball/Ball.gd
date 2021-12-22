extends Area2D

var lift : float = 0.0
var init_velocity : float = 0.0
var velocity : float = 0.0
var angle : float = 0.0
var height : float = 0.0

var lift_mult : float = 3.0
var kicked = false
var time : float = 0.0
var z_time : float = time
var xy_time : float = time
var init_pos = Vector2()
const GRAVITY = 60.0

func _ready():
	init_pos = position
	
func _process(delta):
	if kicked:
		$BallSprite.speed_scale = velocity / 100
		$BallSprite.play('rolling')
		time += delta
		z_time += delta
		xy_time += delta
		height = sin(lift) * init_velocity * z_time / lift_mult - GRAVITY * 0.5 * pow(z_time, 2)
		if height < 0:
			lift_mult *= 1.9
			z_time = 0
		
		$BallSprite.position.y = -height
		position.x -= sin(angle) * cos(lift) * velocity * delta
		position.y -= cos(angle) * cos(lift) * velocity * delta
		velocity = pow(velocity, 2) * 0.9
		print(position)
		$Shadow.modulate.a = 0.2
	else:
		$BallSprite.play('default')
		
func kick(_init_velocity : float, _lift : float, _angle : float):
	lift = _lift
	init_velocity = _init_velocity
	velocity = _init_velocity
	angle = _angle
	kicked = true
