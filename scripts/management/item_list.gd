extends Node
class_name ItemData

var file_system: File
export(String) var path = "res://data/item_data.json"

func get_item_by_name(key: String) -> Dictionary:
	var item: Dictionary = {}
	var item_list: Array = json_loader(path).result
	for item_idx in item_list:
		if item_idx.name == key: 
			item = item_idx
			return item
	print("Dados não encontrados pela key['",key,"']")
	return {}	
	
func get_item_by_id(id: int) -> Dictionary:
	var item_list: Array = json_loader(path).result
	var item: Dictionary = bin_search(item_list, 0, item_list.size()-1, id)
	if item.size()==0:
		print("Dados não encontrados pelo id['",id,"']")
	return item	

func bin_search(list: Array, start: int, end: int, target: int) -> Dictionary:
	#var passos: int = 0
	while(start<=end):
		#passos+=1
		#print(passos)
		var middle: int = (start+end)/2
		if target == list[middle].id:
			#print("Total de passos: ",passos,"; ID do item: ",target," Complexidade O(log2(",passos,"))")
			return list[middle]
		elif target > list[middle].id:
			start = middle+1
			continue
		else:
			end = middle-1
			continue
	return {}
	
	
func json_loader(file_path: String) -> JSONParseResult:
	var system_instance: File = File.new()
	if system_instance.file_exists(file_path):
		var _error: int = system_instance.open(file_path, File.READ)
		var json_result: JSONParseResult = JSON.parse(system_instance.get_as_text())
		system_instance.close()
		return json_result
	print("JSON não pôde ser carregado!")
	return null
