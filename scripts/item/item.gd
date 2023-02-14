extends RigidBody2D
class_name Item

var item_name: String
var item_desc: String
var item_frame_path: String = "res://item"
onready var item_frame: Sprite = get_node("ItemFrame")
var item_sell_value: int
var item_type: String
var item_stats: Dictionary
var item_consumable_info: Dictionary
var has_info: bool = false

func get_item(key: String):
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
		item_stats = info.stats
			
	item_desc = info.desc
	item_frame_path += info.item_frame
	item_sell_value = info.gold_value
	item_type = info.type
	has_info = true
		
			
func spawn_item(item_position: Vector2) -> void:
	if has_info:
		self.global_position = item_position
		var impulse_value: Vector2 = Vector2(rand_range(-10.0, 10.0), rand_range(-50.0, -100.0))
		apply_impulse(Vector2.ZERO, impulse_value)


func _on_Item_ready():
	item_frame.texture = load(item_frame_path)
