extends CanvasLayer

var NONE : int = 0
var MISSED : int = 1
var SCORED : int = 2

var blue_score = [NONE, NONE, NONE, NONE, NONE]
var red_score = [NONE, NONE, NONE, NONE, NONE]

var RED : int = 0
var BLUE : int = 1

var MISSED_COLOR = "#e85959"
var SCORED_COLOR = "#6ae577"
var NONE_COLOR = "#ffffff"
var colors = [NONE_COLOR, MISSED_COLOR, SCORED_COLOR]

onready var blue_nodes = [
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer/Point,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer/Point2,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer/Point3,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer/Point4,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer/Point5
]
onready var red_nodes = [
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer2/Point,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer2/Point2,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer2/Point3,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer2/Point4,
	$MarginContainer/Control/CenterUI/ScoreBar/PointContainer2/Point5
]

onready var timer_text = $MarginContainer/Control/Timer/Label
onready var countdown_text = $MarginContainer/Control/CenterContainer/Label

func updateScore(team : int, _round : int, score : int):
	if team == RED:
		red_score[_round] = score
		red_nodes[_round].modulate = colors[score]
	else:
		blue_score[_round] = score
		blue_nodes[_round].modulate = colors[score]
	printScores()
	
func resetScores():
	for _round in range(0, len(red_score)):
		red_score[_round] = NONE
		red_nodes[_round].modulate = NONE_COLOR
		blue_score[_round] = NONE
		blue_nodes[_round].modulate = NONE_COLOR
		
func printScores():
	print("Blue: " + str(blue_score))
	print("Red: " + str(red_score))
	print()
	
func _ready():
	resetScores()

func updateCountdown(time : float):
	var new_text = str(ceil(time))
	if new_text != countdown_text.text:
		$AudioStreamPlayer.play()
	countdown_text.text = new_text
	
func updateTime(time : float):
	time = stepify(time, 0.1)
	# time in seconds below ten seconds
	# timer_text.text = "0" + str(floor(time)) + " : " + str("%0.2f" % (time - floor(time)))
	timer_text.text = str(time)

func toggleTime():
	timer_text.get_parent().visible = not timer_text.get_parent().visible
	
func toggleCountdown():
	countdown_text.visible = not countdown_text.visible
