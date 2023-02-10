extends Area2D
class_name CollisionArea

onready var timer: Timer = get_node("Timer")
export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
export(NodePath) onready var stats = get_node(stats) as Node
export(float) var immunity_time


func _on_collision_area_entered(area):
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack, "decrease")
		

func update_health(damage: int, type: String) -> void:
	match type:
		"increase":
			pass
			
		"decrease":
			stats.health -= damage
			enemy.hitted = true
			if stats.health<=0:
				enemy.can_die = true
				return
			enemy.stop_move(true)
			enemy.can_hit = true
