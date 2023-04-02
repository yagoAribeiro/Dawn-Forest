extends Item
class_name PhysicalItem

var item_scene: PackedScene = preload("res://scenes/item/item.tscn")
var collect_effect: Resource = preload("res://scenes/env/effects/collect.tscn")
onready var animation: AnimationPlayer = get_node("Animation")
var player_ref: Player
var compressed_data: Dictionary


func _physics_process(_delta: float):
	compressed_data = {
		"item_name": item_name,
		"item_desc": item_desc,
		"quantity": quantity,
		"item_frame_path": item_frame_path,
		"item_sell_value": item_sell_value,
		"item_type": item_type,
		"item_stats": item_stats,
		"item_consumable_info": item_consumable_info,
		"item_id": item_id
		}
	if can_sleep:
		animation.play("idle")
		check_player_action()
	

func check_player_action() -> void:
	if player_ref!= null and Input.is_action_just_pressed("ui_interact"):
		for player_item in player_ref.inventory:
			if player_item.item_name == self.item_name and player_item.item_type!="equipment":
				player_item.quantity+=1
				spawn_effect()
				call_deferred("queue_free")
				return
		var item: Item = item_scene.instance()
		item.descompress_item_info(compressed_data)
		player_ref.inventory.append(item)
		spawn_effect()
		call_deferred("queue_free")

func spawn_item(item_position: Vector2) -> void:
	if has_info:
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.randomize()
		self.global_position = item_position
		var impulse_value: Vector2 = Vector2(rng.randf_range(-30.0, 30.0), rng.randf_range(-80.0, -120.0))
		apply_impulse(Vector2.ZERO, impulse_value)

func spawn_effect()->void:
	var effect: Effect = collect_effect.instance()
	get_tree().root.call_deferred("add_child", effect)
	effect.z_index = z_index
	effect.global_position = global_position
	effect.play_effect()

func _on_PickUpArea_body_entered(player_body: Player):
	player_ref = player_body

func _on_PickUpArea_body_exited(_player_body: Player):
	player_ref = null

func _on_PhysicalItem_ready():
	item_frame.texture = load(item_frame_path)
	item_frame.texture.resource_local_to_scene = true
