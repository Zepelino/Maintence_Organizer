extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var img_container = $"%image_container"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _fill(client, equip, fab, id, arrive, depart, budget, img_path):
	$"%client_label".text = str(client)
	$"%equip_label".text = str(equip)
	$"%fab_label".text = str(fab)
	$"%ID_label".text = str(id)
	
	if arrive != null:
		var arrive_date =  str(arrive).split('-')
		var format_arrive = "%s/%s/%s" % [arrive_date[2], arrive_date[1], arrive_date[0]]
		
		$"%arrive_label".text = format_arrive
	
	if depart != null:
		var depart_date =  str(depart).split('-')
		var format_depart = "%s/%s/%s" % [depart_date[2], depart_date[1], depart_date[0]]
		
		$"%departure_label".text = format_depart
	else:
		$"%departure_label".text = 'Ainda na empresa'
	
	$"%budget_text".text = str(budget)
	
	if img_path == 'None':
		return
	
	#print(Geral.API_URL + '/fetch_file_names/?path=' + img_path.http_escape())
	
	Http.request(Geral.API_URL + '/fetch_file_names/?path=' + img_path.http_escape())
	var result_body = yield(Http, "request_completed")[3]
	
	var file_names = JSON.parse(result_body.get_string_from_utf8()).result
	#print(file_names)
	
	for file in file_names:
		Http.request(Geral.API_URL + '/fetch_image/?path=' + img_path.http_escape() + '&file_name=' + file.http_escape())
		result_body = yield(Http, "request_completed")
		#print("result: ",result_body)
		var response = JSON.parse(result_body[3].get_string_from_utf8()).result
		
		#print("response: ", response)
		var image_bytes = Marshalls.base64_to_raw(response)
		#var image_bytes = image_json.data
		#print("bytes: ", image_bytes)
		var i = Image.new()
		var extension = file.get_extension().to_lower()
		#print(extension)
		
		match extension:
			'png':
				i.load_png_from_buffer(image_bytes)
			'jpg':
				i.load_jpg_from_buffer(image_bytes)
			'jpeg':
				i.load_jpg_from_buffer(image_bytes)
		
		var t = ImageTexture.new()
		t.create_from_image(i)
		
		if t.get_data() == null:
			return
		
		var tr = TextureRect.new()
		tr.expand = true
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.texture = t
		
		img_container.add_child(tr)
		yield(get_tree(),"idle_frame")
		tr.rect_min_size.y = (tr.rect_size.x / t.get_width()) * t.get_height()
		


func _on_back_button_up():
	Geral._call_search_list()
