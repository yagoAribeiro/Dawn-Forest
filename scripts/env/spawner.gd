extends Node2D

class_name Spawner

export(int) var max_quantity: int = 2
export(float) var cooldown: float = 2.0
export(bool) var respawn: bool = true
export(Array, Dictionary) var instances: Array = [
	{
	"scene_path": "",
	"respawn": true,
	"chance": 100.0
	}
]
var quantity: int = 0

func _ready():
	if quantity<max_quantity:
		spawn()


func _process(_delta: float) -> void:
	if quantity<max_quantity and $SpawnerClock.is_stopped():
		$SpawnerClock.start(cooldown)


func spawn() -> void:
	if quantity<max_quantity:
		var chance_collection: ChanceCollection = ChanceCollection.new()
		for scene_instance in instances:
			chance_collection.add(ChanceInstance.new(scene_instance, scene_instance["chance"]))
		var utils: Utils = Utils.new()
		var enemy_data: Dictionary = utils.catch_drop(chance_collection)
		var enemy_instance = load(enemy_data["scene_path"])
		var enemy: EnemyTemplate = enemy_instance.instance()
		get_parent().call_deferred("add_child", enemy)
		enemy.global_position = self.global_position
		var _connected: int = enemy.connect("on_enemy_died", self, "instance_died")
		quantity+=1


func instance_died() -> void:
	quantity-=1


func _on_Spawner_Timeout():
	spawn()

