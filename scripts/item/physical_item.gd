extends Item
class_name PhysicalItem

var item_scene: PackedScene = preload("res://scenes/item/item.tscn")
var player_ref: Player

func _physics_process(_delta: float):
	if player_ref!= null and Input.is_action_just_pressed("ui_interact"):
		var item: Item = item_scene.instance()
		item.descompress_item_info(self.compressed_data)
		player_ref.inventory.append(item)
		call_deferred("queue_free")

func spawn_item(item_position: Vector2) -> void:
	if has_info:
		self.global_position = item_position
		var impulse_value: Vector2 = Vector2(rand_range(-10.0, 10.0), rand_range(-50.0, -100.0))
		apply_impulse(Vector2.ZERO, impulse_value)

func _on_PickUpArea_body_entered(player_body: Player):
	player_ref = player_body

func _on_PickUpArea_body_exited(_player_body: Player):
	player_ref = null

func _on_PhysicalItem_ready():
	item_frame.texture = load(item_frame_path)
	item_frame.texture.resource_local_to_scene = true
