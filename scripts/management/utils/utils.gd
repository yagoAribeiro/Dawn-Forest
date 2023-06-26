extends Node

class_name Utils

func get_random(from: int, to: int) -> int:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi()%to+from
	
func gacha(_list: ChanceCollection, _can_drop_null: bool) -> Array:
	return []

func catch_drop(list: ChanceCollection, _can_drop_null: bool = false) -> Dictionary:
	var rand_int: int = int(get_random(0, list.get_instances().size()))
	return list.get_instances()[rand_int].get_instance_data()

