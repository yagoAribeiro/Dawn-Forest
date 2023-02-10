extends Sprite
class_name EnemyTexture

export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var attack_area_collision = get_node(attack_area_collision) as Area2D
onready var shader_animation: AnimationPlayer = get_node("ShaderAnimations")

func animate(_velocity: Vector2) -> void:
	pass


func _on_animation_finished(_anim_name: String) -> void:
	pass 
	
func shader_animations() -> void:
	pass
