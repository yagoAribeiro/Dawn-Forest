extends Node

class_name ChanceInstance

var data: Dictionary setget, get_instance_data
var chance: float = 0

func _init(data_params: Dictionary, inst_chance: float):
	data = data_params
	chance = inst_chance

func get_instance_data()->Dictionary:
	return data