extends Control


onready var file_dialog := $FileDialog

onready var img_paths_text := $VBoxContainer/row6/TextEdit
var img_paths := []

var previous := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _fill(client, equip, fab, id, arrive, depart, budget):
	
	Http.request(Geral.API_URL + "/write_page_data/")
	
	var response_body = yield(Http,"request_completed")[3]
	
	if response_body:
		var data_to_fill = JSON.parse(response_body.get_string_from_utf8()).result
		
		$"%client_input"._fill(data_to_fill[0])
		$"%fab_input"._fill(data_to_fill[1])
		$"%equip_input"._fill(data_to_fill[2])
	
	$"%client_input"._set_text(client)
	$"%equip_input"._set_text(equip)
	$"%fab_input"._set_text(fab)
	$"%id_input".text = id
	
	var date_arr = arrive.split('-')
	var date = Date.new(int(date_arr[2]), int(date_arr[1]), int(date_arr[0]))
	$"%arrive_date".set_date(date)
	
	if depart:
		date_arr = depart.split('-')
		date = Date.new(int(date_arr[2]), int(date_arr[1]), int(date_arr[0]))
		$"%departure_date".set_date(date)
	
	$"%budget_input".text = budget


func _on_back_button_up():
	Geral._call_search_list()


func _on_submit_button_up():
	
	var node_paths = ['%client_input', '%fab_input', '%equip_input', '%id_input', '%budget_input']
	var values := {}
	var lacking := false
	
	for path in node_paths:
		get_node(path).modulate = Color.white
		
		if get_node(path) is LineEdit or get_node(path) is TextEdit:
			#if get_node(path).text == '':
			#	lacking = true
			#	get_node(path).modulate = Color.firebrick
			#	continue
			#else:
			values[path] = get_node(path).text
		else:
			if get_node(path).line.text == '':
				lacking = true
				get_node(path).modulate = Color.firebrick
			else:
				values[path] = get_node(path).line.text
	
	if lacking:
		return
	
	
	var dict := {'client': values['%client_input'], 'equip': values['%equip_input'], 'fab': values['%fab_input'],\
				'id': values['%id_input'], 'budget': values['%budget_input'] , 'images': [], 'has_images': img_paths.size() > 0,\
				'arrive': get_node("%arrive_date")._get_date(), 'departure': get_node("%departure_date")._get_date(),\
				'previous': previous}
	
	print(previous)
	Http.request(Geral.API_URL + "/edit_entry/", [], false, HTTPClient.METHOD_POST, to_json(dict))
	
	yield(Http,"request_completed")
	
	if img_paths.size() <= 0:
		Geral._go_to("res://src/scenes/SEARCH_PAGE.tscn")
		return
	
	var file = File.new()
	
	for path in img_paths:
		
		file.open(path, File.READ)
		var base_64_data = Marshalls.raw_to_base64(file.get_buffer(file.get_len()))
		
		var body = to_json({'name': path.split("/")[path.split("/").size()-1],'content': base_64_data})
		#print("mandando")
		Http.request(Geral.API_URL + "/edit_entry/image", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, body)
		#print("esperando")
		yield(Http,"request_completed")
		file.close()
	
	
	Geral._go_to("res://src/scenes/SEARCH_PAGE.tscn")


func _on_attach_button_up():
	file_dialog.popup_centered(Vector2(500,460))


func _on_FileDialog_files_selected(paths):
	img_paths = paths
	img_paths_text.text = ''
	for path in paths:
		img_paths_text.text += path + '\n'
