extends Node2D


var goalie_id := 0
var kicker_id := 1

# These values are set for the start of the round do not change unless you know what you are doing
var _round : int = 0
var _play : int = 1

var time_inbetween_rounds = 5

enum {
	GOAL,
	NO_GOAL,
	PLAY,
	PRE_PLAY
}

var state := PRE_PLAY

func _ready():
	# $LocalUI.toggleTime()
	$Timer.start(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$LocalUI.updateTime($Timer.time_left)
	if state == PRE_PLAY:
		$LocalUI.updateCountdown($Timer.time_left)
	elif state == PLAY:
		$LocalUI.updateTime($Timer.time_left)
	elif state == GOAL:
		pass
	elif state == NO_GOAL:
		pass


func _on_Goal_goal():
	if state == PLAY:
		finish_play(true)

func _on_Goal_no_goal():
	if state == PLAY:
		finish_play(false)

func _on_Timer_timeout():
	if state == PRE_PLAY:
		$LocalUI.toggleCountdown()
		# $LocalUI.toggleTime()
		$LocalUI/AudioStreamPlayer2.play()
		state = PLAY
		$Timer.start(5)
	elif state == PLAY:
		finish_play(false)
	elif state == GOAL or state == NO_GOAL:
		state = PRE_PLAY
		var prev_goalie_id = goalie_id
		goalie_id = kicker_id
		kicker_id = prev_goalie_id
		$FieldElements/Goal.reset()
		$Kicker.reset()
		$Ball.reset()
		$Timer.start(5)
		$LocalUI.toggleCountdown()
		_round = floor(float(_play) / 2.0)
		_play += 1

func finish_play(goal : bool):
	if goal:
		state = GOAL
		$LocalUI.updateScore(kicker_id, _round, 2)
	else:
		state = NO_GOAL
		$LocalUI.updateScore(kicker_id, _round, 1)
	# $LocalUI.toggleTime()
	$Timer.start(2)
