extends Area2D
class_name FireBall
var spell_damage: int = 0

func _ready():
	for child in get_node("effects").get_children():
		if child is Particles2D and child.name!="explosions":
			child.emitting = true


func _on_animation_finished(_anim_name: String):
	queue_free()
