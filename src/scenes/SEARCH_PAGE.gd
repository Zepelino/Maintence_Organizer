extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Http.request(Geral.API_URL + "/search_page_data/")
	
	var response_body = yield(Http,"request_completed")[3]
	
	if response_body:
		var data_to_fill = JSON.parse(response_body.get_string_from_utf8()).result
		
		get_node('%client_input')._fill(data_to_fill[0])
		get_node('%fab_input')._fill(data_to_fill[1])
		get_node('%equip_input')._fill(data_to_fill[2])
		get_node('%arrive_selector')._fill(data_to_fill[3])
		get_node('%departure_selector')._fill(data_to_fill[3])
	
	


func _on_cancel_button_up():
	Geral._go_to()


func _on_submit_button_up():
	var dict := {'client': get_node('%client_input')._get_text(), 'equip': get_node('%equip_input')._get_text(),\
				 'fab': get_node('%fab_input')._get_text(), 'id': get_node('%id_input').text,\
				'arrive': get_node("%arrive_selector")._get_date(), 'departure': get_node("%departure_selector")._get_date()}
	
	print(dict)
	
	Http.request(Geral.API_URL + "/search_result/", [], false, HTTPClient.METHOD_POST, to_json(dict))
	
	var response_body = yield(Http,"request_completed")[3]
	
	#print(JSON.parse(response_body.get_string_from_utf8()).result)
	Geral._call_search_list(JSON.parse(response_body.get_string_from_utf8()).result)
