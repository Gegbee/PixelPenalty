extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scroll_speed : float = 40

func _process(delta):
	scroll_offset.x += scroll_speed * delta
