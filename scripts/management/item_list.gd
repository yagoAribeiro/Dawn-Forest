extends Node
class_name ItemData

var file_system: File = File.new()
export(String) var file_path = "res://data/item_data.json"

func load_item_data(key: String) -> Dictionary:
	if file_system.file_exists(file_path):
		var json_result: JSONParseResult
		var item: Dictionary = {}
		var _error: int = file_system.open(file_path, File.READ)
		json_result = JSON.parse(file_system.get_as_text())
		if json_result.result is Dictionary:
			if key in json_result.result: 
				item = json_result.result[key]
			else:
				print("Dados não encontrados pela key['",key,"']")
		else: 
			print("JSON não pôde ser carregado!")
		file_system.close()
		return item
	return {}
		
