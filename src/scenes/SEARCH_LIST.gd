extends Control


var row = preload("res://src/utilities/TableRow.tscn")
onready var content = $Table/PanelContainer2/ScrollContainer/VBoxContainer

var sn = 0
var data = [{'cliente': 'roger', 'tipo': 'Fonte', 'fabricante': 'Adal', \
			'data_entrada': '18/09/2023', 'data_saida': '19/09/2023', 'id': '77777'}]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#set_data(data)


func _set_data(data):
	for entry in data:
		var instance = row.instance()
		instance.name = String(sn)
		content.add_child(instance)
		
		instance._fill(entry.cliente, entry.tipo, entry.fabricante, \
						entry.data_entrada, entry.data_saida, entry.id)
		
		instance.connect("double_click", self, "acess", [sn])
		instance.connect("acess", self, "acess", [sn])
		instance.connect("edit", self, "edit", [sn])
		
		sn = sn+1


func acess(idx):
	Geral._call_read_page(idx)


func edit(idx):
	Geral._call_edit_page(idx)


func _on_back_button_up():
	Geral._go_to("res://src/scenes/SEARCH_PAGE.tscn")


func _on_read_button_up():
	if get_focus_owner():
		acess(int(get_focus_owner().name))


func _on_edit_button_up():
	if get_focus_owner():
		edit(int(get_focus_owner().name))
