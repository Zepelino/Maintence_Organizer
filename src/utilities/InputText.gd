extends HBoxContainer

onready var popup = $LineEdit/Popup
onready var line = $LineEdit

var itens: = ['adalberto', 'bonoro', 'gabriel', 'rochedo', 'aline', 'bline']

export(int, 'Alpha-Numeric', 'Numeric') var type 

# Called when the node enters the scene tree for the first time.
func _ready():
	_fill(itens)


func _get_text():
	return line.text.strip_edges()


func _set_text(text: String):
	line.text = text


func _fill(data):
	popup.clear()
	itens = data
	for item in data:
		popup.add_item(String(item))


func _on_LineEdit_text_changed(new_text):
	if type == 1:
		for letter in new_text:
			if not letter.is_valid_integer():
				
				new_text.erase(new_text.find(letter), 1)
				var c_pos = line.caret_position - 1
				line.text = new_text
				line.caret_position = c_pos
		
		var rect = line.get_global_rect() 
		popup.popup(Rect2(rect.position.x, rect.position.y + rect.size.y, rect.size.x, rect.size.y))
		return
	
	popup.clear()
	
	var empty: = true
	
	for item in itens:
		if item.to_lower().begins_with(new_text.to_lower()):
			popup.add_item(item)
			empty = false
	
	if empty:
		popup.hide()
		return
	
	var rect = line.get_global_rect() 
	popup.popup(Rect2(rect.position.x, rect.position.y + rect.size.y, rect.size.x, rect.size.y))
	


func _on_Popup_index_pressed(index):
	line.text = popup.get_item_text(index)


func _on_Button_button_up():
	var rect = line.get_global_rect() 
	popup.popup(Rect2(rect.position.x, rect.position.y + rect.size.y, rect.size.x, rect.size.y))
