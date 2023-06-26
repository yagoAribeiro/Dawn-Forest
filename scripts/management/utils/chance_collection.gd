extends Node

class_name ChanceCollection

var instances: Array = [] setget, get_instances

func add(chance_instance: ChanceInstance) -> void:
	instances.append(chance_instance)

func get_instances() -> Array:
	return instances
