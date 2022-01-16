extends Node2D

var goal_height : int = 0.0
var inside_net : bool = false
var cur_swing : float = 0.01
var new_swing : float = 0.0

func _ready():
	goal_height = -$Bar.position.y
	
func _process(_delta):
	cur_swing = lerp(cur_swing, 0.01, 0.02)
	$BackNet.material.set_shader_param("amplitude", cur_swing)
	var ball_height = get_parent().get_node('Ball').height
	$Lines.position.y = -ball_height
	if ball_height > goal_height and inside_net == false:
		if ball_height < goal_height + 2:
			$Bar/Bar.disabled = false
		else:
			$Bar/Bar.disabled = true
		$GoalTop.z_index = 0
		disable_back(true)
	else:
		$Bar/Bar.disabled = true
		$GoalTop.z_index = 2
		disable_back(false)
		
func _on_Front_body_entered(body):
	if body.is_in_group('ball'):
		inside_net = not inside_net

func disable_back(what : bool):
	$Lines/Back/Back.disabled = what
	$Lines/Front/GoalLine.disabled = what
	$Lines/Posts/PostLeft.disabled = what
	$Lines/Posts/PostRight.disabled = what
	
func jiggle(power : float):
	cur_swing = power
	$BackNet.material.set_shader_param("amplitude", cur_swing)
