extends Node

var img_storage_path := "C:\\Users\\Tintepoxi\\Desktop\\teste_godot"
var API_URL = "http://127.0.0.1:8000"

var search_result = []

func _call_search_list(entries: Array = search_result):
	get_tree().change_scene("res://src/scenes/SEARCH_LIST.tscn")
	
	yield(get_tree(), "node_removed")
	yield(get_tree(), "node_added")
	yield(get_tree().current_scene, "ready")
	
	search_result = entries
	get_tree().current_scene._set_data(entries)


func _call_read_page(idx):
	get_tree().change_scene("res://src/scenes/READ_PAGE.tscn")
	
	yield(get_tree(), "node_removed")
	yield(get_tree(), "node_added")
	yield(get_tree().current_scene, "ready")
	
	var selected = search_result[idx]
	
	get_tree().current_scene._fill(selected.cliente, selected.tipo, selected.fabricante,\
									selected.id, selected.data_entrada, selected.data_saida,\
									selected.orcamento, selected.imagens)


func _call_edit_page(idx):
	get_tree().change_scene("res://src/scenes/EDIT_PAGE.tscn")
	
	yield(get_tree(), "node_removed")
	yield(get_tree(), "node_added")
	yield(get_tree().current_scene, "ready")
	
	var selected = search_result[idx]
	
	get_tree().current_scene._fill(selected.cliente, selected.tipo, selected.fabricante,\
									selected.id, selected.data_entrada, selected.data_saida,\
									selected.orcamento)
	
	get_tree().current_scene.previous = selected


func _go_to(path: String = "res://src/scenes/Main.tscn"):
	search_result = []
	get_tree().change_scene(path)
