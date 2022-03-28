extends Control

onready var player_1 = $Main/VBoxContainer/CenterContainer/HSplitContainer/Player1
onready var player_2 = $Main/VBoxContainer/CenterContainer/HSplitContainer/Player2
onready var pings = [player_1.get_node("Label"), player_2.get_node("Label")]
onready var readys = [player_1.get_node("HBoxContainer2/Ready"), player_2.get_node("HBoxContainer2/Ready")]
var ready : Array = [false, false]
var player_colors : Array = ["", ""]
onready var fade : Tween = $TweenFade
onready var swipe : Tween = $TweenSwipe
var current_menu = "main"
onready var menu_info = {
	"main" : $Main,
	"controls" : $Controls,
	"balls" : $Balls
}

func _input(event):
	if event.device <= 1:
		if current_menu == "main":
			if event.is_action_pressed("ping"):
				pings[event.device].set("custom_colors/font_color", "#ef46f9")
			elif event.is_action_released("ping"):
				pings[event.device].set("custom_colors/font_color", "#ffffff")
			if event.is_action_pressed("ready"):
				ready[event.device] = true
				readys[event.device].set("text", "ready!")
				readys[event.device].set("custom_colors/font_color", "#ffffff")
				readys[event.device].set("custom_colors/font_color_shadow", "#39000000")
				readys[event.device].get_parent().get_node("TextureRect").texture = load("res://Buttons/XboxB.png")
				if ready[0] and ready[1]:
					print("GAME TIME")
			elif event.is_action_pressed("unready"):
				ready[event.device] = false
				readys[event.device].set("text", "unready")
				readys[event.device].set("custom_colors/font_color", "#68ffffff")
				readys[event.device].set("custom_colors/font_color_shadow", "#00000000")
				readys[event.device].get_parent().get_node("TextureRect").texture = load("res://Buttons/XboxA.png")
			if event.is_action_pressed("controls"):
				change_menu("controls")
			if event.is_action_pressed("balls"):
				change_menu("balls")
		elif current_menu == "controls":
			if event.is_action_pressed("controls"):
				change_menu("main")
		elif current_menu == "balls":
			if event.is_action_pressed("controls"):
				change_menu("main")
				
func change_menu(menu_id : String):
	var cur = menu_info[current_menu]
	var new = menu_info[menu_id]
	new.rect_position = Vector2(1920, 0)
	cur.rect_position = Vector2(0, 0)
	current_menu = menu_id
	fade.stop(new)
	swipe.stop(cur)
	fade.interpolate_property(cur, "rect_position", cur.rect_position, Vector2(-1920, 0), 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	fade.start()
	swipe.interpolate_property(new, "rect_position", new.rect_position, Vector2(0, 0), 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	swipe.start()
