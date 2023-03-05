extends RigidBody2D
class_name Item

var item_name: String
var item_desc: String
var quantity: int = 1
var item_frame_path: String = "res://item"
onready var item_frame: Sprite = get_node("ItemFrame")
var item_sell_value: int
var item_type: String
var item_stats: Dictionary
var item_consumable_info: Dictionary
var has_info: bool = false

func get_data(key: String):
	var item_list: ItemData = ItemData.new()
	var item_info: Dictionary = item_list.load_item_data(key)
	if item_info.size()!=0:
		item_name = key
		apply_item_info(item_info)
		return self
	return null

func apply_item_info(info: Dictionary) -> void:
	if "consumable_info" in info:
		item_consumable_info = info.consumable_info
	
	if "stats" in info:	
		gacha_stats(info.stats)	
		item_stats = info.stats
			
	item_desc = info.desc
	item_frame_path += info.item_frame
	item_sell_value = info.gold_value
	item_type = info.type
	has_info = true

func gacha_stats(stats: Dictionary) -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var number: int = rng.randi()%20+1
	var prefix: String = ""
	var multiplier: float = 1.0
	if number<=5:
		prefix = "(Broken) "
		multiplier = 0.5
	elif number<=10:
		prefix ="(Damaged) "
		multiplier = 0.75
	elif number<=14:
		prefix ="(Natural) "
		multiplier = 1.0
	elif number<=19:
		prefix = "(Relic) "
		multiplier = 1.5
	else:
		prefix = "(Legendary) "
		multiplier = 2.0
	item_name = prefix+item_name
	for stat in stats:
		stats[stat] = int(float(multiplier*stats[stat]))	
	
func descompress_item_info(item_data: Dictionary) -> void:
	self.item_name = item_data.item_name
	self.item_desc = item_data.item_desc
	self.quantity = item_data.quantity
	self.item_frame_path = item_data.item_frame_path
	self.item_sell_value = item_data.item_sell_value
	self.item_type = item_data.item_type
	self.item_stats = item_data.item_stats
	self.item_consumable_info = item_data.item_consumable_info
	has_info = true

func _on_Item_ready():
	item_frame.texture = load(item_frame_path)
	item_frame.texture.resource_local_to_scene = true
