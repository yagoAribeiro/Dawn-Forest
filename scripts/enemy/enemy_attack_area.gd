extends Area2D
class_name EnemyAttackArea

export(int) var damage
export(int) var invencibility_time
onready var collision: CollisionShape2D = get_node("Collision")
