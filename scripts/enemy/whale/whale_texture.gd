extends EnemyTexture
class_name WhaleTexture

func _ready():
	enemy.drop_list = [
	#Ordem de raridade decrescente
	{"name": "Whale Tail", "id": 4, "chance": 25.0},
	{"name": "Whale Eye", "id": 3, "chance": 25.0},
	{"name": "Health Potion", "id": 0, "chance": 15.0},
	{"name": "Mana Potion", "id": 1, "chance": 15.0},
	{"name": "Whale Mask", "id": 2, "chance": 1.5}
]

func animate(velocity: Vector2) -> void:
	shader_animations()
	if enemy.can_hit or enemy.can_die or enemy.can_attack:
		action_behavior()
	else:
		move_behavior(velocity)
		
func shader_animations() -> void:
	if enemy.hitted and animation.current_animation!="hit":
		shader_animation.play("blink")
	
func move_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
		enemy.looking_back = false
	else:
		animation.play("idle")
	
func action_behavior() -> void:
	if enemy.can_die:
		animation.play("dead")
		attack_area_collision.collision.disabled = true
		enemy.can_hit = false
		enemy.can_attack = false
		enemy.hitted = false
		enemy.stop_move(true)
		
	elif enemy.can_attack:
		enemy.hitted = false
		animation.play("attack")
		
	elif enemy.can_hit:
		if enemy.hitted and animation.current_animation == "hit":
			animation.stop()
			
		animation.play("hit")
		enemy.can_attack = false	
		enemy.hitted = false
		
		
func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"hit": 
			enemy.can_hit = false
			enemy.hitted = false
			enemy.can_attack = false
			enemy.stop_move(false)
		
		"attack":
			enemy.can_attack = false
			enemy.can_hit = false
			enemy.stop_move(false)
			
		"dead":
			animation.play("despawn")
			enemy.drop_item()
			
		"despawn":
			enemy.queue_free()
		
		"blink":
			shader_animation.stop()
			
		"idle":
			enemy.looking_back = false
			if enemy.current_state == enemy.move_state.PATROL:
				enemy.last_direction.x *=-1
