extends KinematicBody2D

var init_pos =  Vector2()
var moving = false
var time : float = 0.0

const GRAVITY = 120.0
const FRICTION_COEFFICIENT : float = 0.975 # 0 - 1
const AIR_RESISTANCE_COEFFICIENT : float = 0.995 # 0 - 1
var lift_mult : float = 0.5 # 0 - 1

var vel = Vector3()
var pos = Vector3()
var height : float = 0.0
var prev_vel = Vector3()

func _ready():
	$Shadow.modulate.a = 0.4
	init_pos = global_position
	
func _physics_process(delta):
	if moving:
		time += delta
		height += (vel.z - GRAVITY * time) * delta
		if height <= 0:
			height = 0
			if abs(vel.z - GRAVITY * time) > 4:
				$Grass.pitch_scale = 0.6 + randf() * 0.2
				$Grass.volume_db = abs(vel.z - GRAVITY * time) * 0.2 - 15
				$Grass.play()
			move(vel.x, vel.y, -(vel.z - GRAVITY * time) * lift_mult)
			
		var speed = Vector2(vel.x, vel.y)
		if height < 0.5:
			var friction = FRICTION_COEFFICIENT
			vel.y *= friction
			vel.x *= friction
		else:
			var air_resistance = AIR_RESISTANCE_COEFFICIENT
			vel.y *= air_resistance
			vel.x *= air_resistance
			
		var collision = move_and_collide(speed * delta)
		if collision:
			var speed_mult = 1.0
			if collision.collider.is_in_group('post') or collision.collider.is_in_group('bar'):
				$Bar.pitch_scale = 0.9 + (randf() * 0.5 - 0.25)
				$Bar.volume_db = vel.length() * 0.02
				$Bar.play()
				speed_mult = 0.7
			elif collision.collider.is_in_group('net'):
				$Net.pitch_scale = 0.6 + (randf() * 0.2 - 0.1)
				$Net.volume_db = vel.length() * 0.04 - 30
				$Net.play()
				speed_mult = 0.1
				collision.collider.get_parent().get_parent().jiggle(0.0002 * vel.length())
			var reflection_speed = speed.bounce(collision.normal) * speed_mult
			move(reflection_speed.x, reflection_speed.y, (vel.z - GRAVITY * time))
			
		$CollisionShape2D.position.y = -height
		$Ball.position.y = -height
		
		if abs(speed.length()) > 20:
			$Ball/BallSprite.play('rolling')
			$Ball/BallSprite.speed_scale = 1.5
		else:
			$Ball/BallSprite.play('default')
		if abs(vel.length()) < 10:
			moving = false
			get_tree().reload_current_scene()
	else:
		
		$Ball/BallSprite.play('default')
		
func move(x_vel : float, y_vel : float, z_vel : float):
	if abs(z_vel) < 0.01:
		z_vel = 0
	if Vector2(x_vel, y_vel).length() < 0.01:
		x_vel = 0
		y_vel = 0
	vel = Vector3(x_vel, y_vel, z_vel)
	time = 0
	moving = true

func reset():
	moving = false
	time = 0
	vel = Vector3()
	height = 0
	global_position = init_pos
