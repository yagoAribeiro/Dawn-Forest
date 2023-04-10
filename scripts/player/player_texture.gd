extends Sprite
class_name PlayerTexture

signal game_over
var suffix: String = "_right"
var normal_attack: bool = false
var magic_attack: bool = false
var shield_off: bool = false
var crouching_off: bool = false

export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var attack_collision = get_node(attack_collision) as CollisionShape2D
export(NodePath) onready var light_animation = get_node(light_animation) as AnimationPlayer

func animate(direction: Vector2) -> void:
	verify_position(direction)
	if player.light_on:
		light_animation.play("light_anim")
		
	if player.on_hit or player.dead:
		hit_behavior()
	elif player.attacking or player.crouching or player.defending or player.wall_sliding:
		action_behavior()
	elif direction.y !=0:
		vertical_behavior(direction)
	elif player.landing and player.is_on_floor():
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	
	
	
func verify_position(direction: Vector2) -> void:
	if direction.x>0:
		flip_h = false
		suffix = "_right"
		player.wall_direction = -1
		player.spell_offset.x = abs(player.spell_offset.x)
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(5.5, 0)
		
	elif direction.x<0:
		flip_h = true
		suffix = "_left"
		player.wall_direction = 1
		player.spell_offset.x *= -1 if player.spell_offset.x>0 else 1
		position = Vector2(-2, 0)
		player.wall_ray.cast_to = Vector2(position.x-5.5, 0)


func hit_behavior() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	if player.dead:
		animation.play("dead")
	elif player.on_hit:
		animation.play("hit")		

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x !=0:
		animation.play("run"+suffix)
	else:
		animation.play("idle")
	
func action_behavior() -> void:
	if player.wall_sliding:
		animation.play("wall_slide"+suffix)
	
	elif player.attacking and magic_attack:
		animation.play("magic_attack")
		
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix)
		
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false
		
	elif player.crouching and crouching_off:
		animation.play("crouch")
		crouching_off = false
		
func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	elif direction.y <0:
		animation.play("jump")


func _on_animation_finished(anim_name: String):
	match(anim_name):
		"landing":
			player.landing = false
			player.set_physics_process(true)
			
		"attack_left":
			normal_attack = false
			player.attacking = false 
			
		"attack_right":
			normal_attack = false
			player.attacking = false 
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending:
				animation.play("shield")
			
			if player.crouching:
				animation.play("crouch")
		
		"dead":
			yield(get_tree().create_timer(4), "timeout")
			emit_signal("game_over")
		
		"light_anim":
			if !player.light_on:
				light_animation.stop()
				
		"magic_attack":
			magic_attack = false
			player.attacking = false
			


		
