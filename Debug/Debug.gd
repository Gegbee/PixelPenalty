extends CanvasLayer



func add_debug_label(_name : String):
	var new_label = Label.new()
	$VBoxContainer.add_child(new_label)
	new_label.name = _name
	
func update_debug_label(_name, data):
	$VBoxContainer.get_node(_name).text = str(_name + ": " + data)
