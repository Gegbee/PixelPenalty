extends Node2D


var init_position : Vector2 = Vector2()

func _ready():
	init_position = $Line.position
	
func _process(_delta):
	$Line.position.y = init_position.y - get_parent().get_node('Ball').height
