extends Area2D
class_name DetectionArea

export(NodePath) onready var enemy = get_node(enemy) as EnemyTemplate



func _on_body_entered(body: Player):
	enemy.player_ref = body

func _on_body_exited(_body: Player):
	enemy.player_ref = null


