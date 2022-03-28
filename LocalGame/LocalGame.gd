extends Node2D


var goalie_id := 0
var kicker_id := 1

enum state {
	GOAL,
	NO_GOAL,
	PLAY,
	PRE_PLAY
}

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Goal_goal(team : int):
	$LocalUI.updateScore(team, 1, 2)


func _on_Goal_no_goal(team : int):
	$LocalUI.updateScore(team, 1, 1)
