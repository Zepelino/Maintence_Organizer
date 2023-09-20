extends Control

onready var file_dialog := $FileDialog

onready var img_paths_text := $VBoxContainer/row6/TextEdit
var img_paths := []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("%arrive_date").set_date(Date.new())
	
	Http.request(Geral.API_URL + "/write_page_data/")
	
	var response_body = yield(Http,"request_completed")[3]
	
	if response_body:
		var data_to_fill = JSON.parse(response_body.get_string_from_utf8()).result
		
		get_node('%client_input')._fill(data_to_fill[0])
		get_node('%fab_input')._fill(data_to_fill[1])
		get_node('%equip_input')._fill(data_to_fill[2])
	
	#Http.request(Geral.API_URL + "/write_entry/image", [], false, HTTPClient.METHOD_POST, )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_attach_button_up():
	file_dialog.popup_centered(Vector2(500,460))



func _on_cancel_button_up():
	Geral._go_to()


func _on_submit_button_up():
	
	var node_paths = ['%client_input', '%fab_input', '%equip_input', '%id_input', '%budget_input']
	var values := {}
	var lacking := false
	
	for path in node_paths:
		get_node(path).modulate = Color.white
		
		if get_node(path) is LineEdit or get_node(path) is TextEdit:
			if get_node(path).text == '':
				lacking = true
				get_node(path).modulate = Color.firebrick
				continue
			else:
				values[path] = get_node(path).text
		else:
			if get_node(path).line.text == '':
				lacking = true
				get_node(path).modulate = Color.firebrick
			else:
				values[path] = get_node(path).line.text
	
	if lacking:
		return
	
	print(img_paths.size() > 0)
	
	
	var dict := {'client': values['%client_input'], 'equip': values['%equip_input'], 'fab': values['%fab_input'],\
				'id': values['%id_input'], 'budget': values['%budget_input'] , 'images': [], 'has_images': img_paths.size() > 0,\
				'arrive': get_node("%arrive_date")._get_date(), 'departure': get_node("%departure_date")._get_date()}
	
	Http.request(Geral.API_URL + "/write_entry/", [], false, HTTPClient.METHOD_POST, to_json(dict))
	
	yield(Http,"request_completed")

	print(img_paths)
	if img_paths.size() <= 0:
		Geral._go_to()
		return
	
	var file = File.new()
	for path in img_paths:
		
		file.open(path, File.READ)
		var base_64_data = Marshalls.raw_to_base64(file.get_buffer(file.get_len()))
		
		var body = to_json({'name': path.split("/")[path.split("/").size()-1],'content': base_64_data})
		#print("mandando")
		Http.request(Geral.API_URL + "/write_entry/image", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, body)
		#print("esperando")
		yield(Http,"request_completed")
		
		file.close()
	
	Http.request(Geral.API_URL + "/write_entry/stop", [], false, HTTPClient.METHOD_POST)
	#var body = PoolByteArray()
	#body.append_array( "\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L\r\n".to_utf8())
	#body.append_array( "Content-Disposition: form-data; name=\"img\"; filename=\"img.png\"\r\n".to_utf8())
	#body.append_array( "Content-Type: image/png\r\n\r\n".to_utf8())
	#body.append_array(data_to_send.to_utf8())
	#body.append_array( "\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L--\r\n".to_utf8())
	#var headers = ["Content-Type: multipart/form-data; boundary=\"WebKit FormBoundaryePkpFF7tjBAqx29L\""]
	
	
	#Http.request_raw(Geral.API_URL + "/write_entry/", headers, false, HTTPClient.METHOD_POST, body)
	#print(body)
	
	Geral._go_to()


func _on_FileDialog_files_selected(paths):
	img_paths = paths
	img_paths_text.text = ''
	for path in paths:
		img_paths_text.text += path + '\n'
