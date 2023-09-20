extends Control


signal double_click
signal acess
signal edit

var mouse_inside: = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _fill(client, equip, fab, arrive, departure, id):
	get_node("HBoxContainer/1").text = str(client)
	get_node("HBoxContainer/2").text = str(equip)
	get_node("HBoxContainer/3").text = str(fab)
	
	#get_node("HBoxContainer/4").text = str(arrive)
	#get_node("HBoxContainer/5").text = str(departure)
	if arrive != null:
		var arrive_date =  str(arrive).split('-')
		var format_arrive = "%s/%s/%s" % [arrive_date[2], arrive_date[1], arrive_date[0]]
		
		$"HBoxContainer/4".text = format_arrive
	
	if departure != null:
		var depart_date =  str(departure).split('-')
		var format_depart = "%s/%s/%s" % [depart_date[2], depart_date[1], depart_date[0]]
		
		$"HBoxContainer/5".text = format_depart
	else:
		$"HBoxContainer/5".text = 'Ainda na empresa'
	
	get_node("HBoxContainer/6").text = str(id)


func _on_Control_focus_entered():
	$Highlight.show()


func _on_Control_focus_exited():
	$Highlight.hide()


func _input(event):
	if mouse_inside and has_focus() and event is InputEventMouseButton and event.button_index == 2:
		$menu.popup(Rect2(get_global_mouse_position(), Vector2(70, 56)))
	if has_focus() and event is InputEventMouseButton and event.doubleclick and event.button_index == 1:
		emit_signal("double_click")


func _on_menu_index_pressed(index):
	match index:
		0:
			emit_signal("acess")
		1:
			emit_signal("edit")


func _on_TableRow_mouse_entered():
	mouse_inside = true


func _on_TableRow_mouse_exited():
	mouse_inside = false
