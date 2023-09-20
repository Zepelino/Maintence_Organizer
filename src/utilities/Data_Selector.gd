
extends HBoxContainer


var date: = ''
export var required : bool = false

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
