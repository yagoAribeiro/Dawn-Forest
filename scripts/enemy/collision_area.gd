extends Area2D
class_name CollisionArea

onready var timer: Timer = get_node("Timer")
export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate
export(NodePath) onready var stats = get_node(stats) as EnemyStats
export(PackedScene) var floating_text: PackedScene
export(float) var immunity_time


func _on_collision_area_entered(area):
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack, "decrease")
	elif area is FireBall:
		update_health(area.spell_damage, "decrease")
		set_deferred("monitoring", false)
		timer.start(immunity_time)
		

func update_health(damage: int, type: String) -> void:
	match type:
		"increase":
			pass
			
		"decrease":
			stats.health -= damage
			spawn_floating_text("Damage", "-", damage)
			enemy.hitted = true
			if stats.health<=0:
				set_deferred("monitorable", false)
				set_deferred("monitoring", false)
				enemy.dies()
				return
			enemy.stop_move(true)
			enemy.can_hit = true


func _on_Timer_timeout():
	if !enemy.can_die:
		set_deferred("monitoring", true)

func spawn_floating_text(type: String, type_sign: String, value: int) -> void:
	var text: FloatText = floating_text.instance()
	text.rect_global_position = enemy.global_position
	text.type = type
	text.value = value
	text.type_sign = type_sign
	get_tree().root.call_deferred("add_child", text)
