extends AnimatedSprite
class_name Effect

func play_effect() -> void:
	play()

func _on_Effect_animation_finished():
	queue_free()
