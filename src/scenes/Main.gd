extends Control


onready var http = $HTTPRequest


# Called when the node enters the scene tree for the first time.
func _ready():
	#http.request("http://127.0.0.1:8000/search_result/?client=Dmk")
	#var result = yield(http, "request_completed")
	#print(JSON.parse(result[3].get_string_from_utf8()).result)
	#print("http://127.0.0.1:8000/fetch_file_names/?path=" + "C:\\Users\\Tintepoxi\\Desktop\\TESTESERVER\\2023\\Imagem simples\\aaaaaaaaaaa\\2023-09-19".http_escape())
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_add_button_up():
	get_tree().change_scene("res://src/scenes/WRITE_PAGE.tscn")


func _on_search_button_up():
	get_tree().change_scene("res://src/scenes/SEARCH_PAGE.tscn")
