class_name DataIO
extends Node

var filepath:String = "res://file_index.json"

func readJSON() ->Variant:
	var json_data
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			json_data = json.data			
	file.close()
	return json_data

func writeJSON(data)->void:
	var json_string: String = JSON.stringify(data, "\t")
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()

static func read_file(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content
