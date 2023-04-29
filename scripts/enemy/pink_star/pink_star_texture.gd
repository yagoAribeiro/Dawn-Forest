extends EnemyTexture

class_name PinkStarTexture
var suffix: String = ""

func animate(velocity: Vector2)->void:
	shader_animations()
	if flip_h:
		suffix = "_right"
	else:
		suffix = "_left"
	if enemy.can_hit or enemy.can_die or enemy.can_attack:
		action_behavior()
	else:
		move_behavior(velocity)
	
func action_behavior()->void:
	if enemy.can_die:
		animation.play("dead")
		attack_area_collision.collision.set_deferred("disabled", true)
		enemy.can_hit = false
		enemy.can_die = false
		enemy.can_attack = false
		enemy.hitted = false
		enemy.stop_move(true)
		
	elif enemy.can_attack:
		animation.play("attack_antecipation")
		enemy.set_physics_process(false)
		enemy.can_hit = false
		enemy.hitted = false
		enemy.stop_move(true)
		
	elif enemy.can_hit:
		if enemy.hitted and animation.current_animation == "hit":
			animation.stop()
			
		animation.play("hit")
		enemy.can_attack = false	
		enemy.hitted = false
		
		

func move_behavior(velocity: Vector2)->void:
	if velocity.x!=0:
		animation.play("run")
	else:
		animation.play("idle")

func _on_animation_finished(anim_name: String) -> void:
	match(anim_name):
		"idle":
			if enemy.current_state == enemy.move_state.PATROL:
				enemy.last_direction.x*=-1	
		"hit":
			enemy.hitted = false
			enemy.can_hit = false
			enemy.can_attack = false
			enemy.stop_move(false)
			
		"attack_antecipation":
			animation.play("attack"+suffix)
			
		"attack_left":
			enemy.can_attack = false
			enemy.set_physics_process(true)
			enemy.stop_move(false)
		
		"attack_right":
			enemy.can_attack = false
			enemy.set_physics_process(true)
			enemy.stop_move(false)
		
		"dead":
			animation.play("despawn")
			
		"blink":
			shader_animation.stop()
			
		"despawn":
			queue_free()
