extends HBoxContainer


func _ready():
	get_node('%InputDay')._fill(['desconhecido'])
	get_node("%InputMonth")._fill(['desconhecido', '01', '02', '03', '04', '05', '06', '07',\
									'08', '09', '10', '11', '12'])


func _get_date():
	var ano = get_node("%InputYear")._get_text()
	var mes = get_node("%InputMonth")._get_text()
	var dia = get_node("%InputDay")._get_text()
	
	if ano == 'desconhecido':
		ano = ''
	if mes == 'desconhecido':
		mes = ''
	if dia == 'desconhecido':
		dia = ''
	
	return [ano, mes, dia]


func _fill(years):
	get_node("%InputYear")._fill(years)


func _on_CalendarButton_date_selected(date_obj):
	get_node("%InputYear")._set_text("%04d" % date_obj.year)
	get_node("%InputMonth")._set_text("%02d" % date_obj.month)
	get_node("%InputDay")._set_text("%02d" % date_obj.day)
