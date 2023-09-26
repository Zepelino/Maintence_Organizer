
extends HBoxContainer


var date: = ''
export var required : bool = false
onready var line: = $Line
var former_text: = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_date():
	
	if date:
		return "'%s'" % date
	
	if required:
		var new_date = Date.new()
		return "'%s%s%s'"%["%04d" % new_date.year, "%02d" % new_date.month, "%02d" % new_date.day]
	
	return "NULL"

func set_date(new_date):
	date = "%s%s%s"%["%04d" % new_date.year, "%02d" % new_date.month, "%02d" % new_date.day]
	$Line.text = "%s/%s/%s"%["%02d" % new_date.day, "%02d" % new_date.month, "%04d" % new_date.year]


func _on_CalendarButton_date_selected(new_date):
	set_date(new_date)


func _on_Line_text_changed(new_text):
	if former_text.length() > new_text.length():
		former_text = new_text
		return
	
	while not new_text[new_text.length() - 1].is_valid_integer():
		new_text[new_text.length() - 1] = ''
		var pos = line.caret_position
		line.text = new_text
		line.caret_position = pos
		return
	
	var pos = line.caret_position
	
	if new_text.length() >= 3:
		new_text[2] = "/"
		pos = line.caret_position + 1
	
	if new_text.length() >= 6:
		new_text[5] = "/"
		pos = line.caret_position + 1
	
	if new_text.length() == 2 or new_text.length() == 5:
		new_text += "/"
		pos = line.caret_position + 1
	
	while new_text.length() > 10:
		new_text[10] = ''
	
	line.text = new_text
	line.caret_position = pos
	
	former_text = new_text
	
	if new_text.length() == 10:
		var new_date = new_text.split('/')
		date = "%s%s%s"%["%04d" % int(new_date[2]), "%02d" % int(new_date[1]), "%02d" % int(new_date[0])]


