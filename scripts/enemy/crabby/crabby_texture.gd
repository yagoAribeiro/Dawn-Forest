extends EnemyTexture

class_name CrabbyTexture
onready var attack_effect: Resource = preload("res://scenes/env/effects/crabby_attack.tscn")
export(NodePath) onready var attack_cooldown = get_node(attack_cooldown) as Timer 
var attack_in_cooldown: bool = false

func animate(velocity: Vector2) -> void:
	
	shader_animations()
	if enemy.can_hit or enemy.can_die or enemy.can_attack:
		action_behavior()
	else:
		move_behavior(velocity)
	
func move_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
	
func action_behavior() -> void:
	if enemy.can_die:
		animation.play("dead")
		attack_area_collision.collision.set_deferred("disabled", true)
		enemy.can_hit = false
		enemy.can_attack = false
		enemy.hitted = false
		enemy.stop_move(true)
		
	elif enemy.can_hit:
		animation.play("hit")
		enemy.can_attack = false	
		enemy.hitted = false
		
	elif enemy.can_attack and !attack_in_cooldown:
		enemy.hitted = false
		animation.play("attack")

func make_effect()->void:
	var effect_instance: Effect = attack_effect.instance()
	get_tree().root.call_deferred("add_child", effect_instance)
	effect_instance.global_position = enemy.global_position
	effect_instance.play_effect()

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"hit": 
			enemy.can_hit = false
			enemy.hitted = false
			enemy.can_attack = false
			enemy.stop_move(false)
		
		"attack":
			enemy.can_attack = false
			attack_in_cooldown = true
			enemy.can_hit = false
			enemy.stop_move(false)
			
		"dead":
			animation.play("despawn")
			
		"despawn":
			enemy.queue_free()
		
		"blink":
			shader_animation.stop()
			
		"idle":
			if enemy.current_state == enemy.move_state.PATROL:
				enemy.last_direction.x *=-1 
	


func _on_AttackCooldown_timeout():
	attack_in_cooldown = false
	if enemy.player_ref == null:
		enemy.can_attack = false
