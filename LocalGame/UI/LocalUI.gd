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
	$MarginContainer/Control/SideUI/Atk/PointContainer/Point,
	$MarginContainer/Control/SideUI/Atk/PointContainer/Point2,
	$MarginContainer/Control/SideUI/Atk/PointContainer/Point3,
	$MarginContainer/Control/SideUI/Atk/PointContainer/Point4,
	$MarginContainer/Control/SideUI/Atk/PointContainer/Point5
]
onready var red_nodes = [
	$MarginContainer/Control/SideUI/Def/PointContainer2/Point,
	$MarginContainer/Control/SideUI/Def/PointContainer2/Point2,
	$MarginContainer/Control/SideUI/Def/PointContainer2/Point3,
	$MarginContainer/Control/SideUI/Def/PointContainer2/Point4,
	$MarginContainer/Control/SideUI/Def/PointContainer2/Point5
]

func updateScore(team : int, number : int, score : int):
	if team == RED:
		red_score[number - 1] = score
		red_nodes[number - 1].modulate = colors[score]
	else:
		blue_score[number - 1] = score
		blue_nodes[number - 1].modulate = colors[score]

func resetScores():
	for number in range(0, len(red_score)):
		red_score[number] = NONE
		red_nodes[number].modulate = NONE_COLOR
		blue_score[number] = NONE
		blue_nodes[number].modulate = NONE_COLOR
		
func printScores():
	print("Blue: " + str(blue_score))
	print("Red: " + str(red_score))
	print()
	
func _ready():
	resetScores()
	printScores()
