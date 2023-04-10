extends KinematicBody2D

class_name Player

onready var player_sprite: Sprite = get_node("Texture")
onready var wall_ray: RayCast2D = get_node("WallRay")
onready var stats: Node = get_node("Stats")
onready var FIREBALL: Resource = preload("res://scenes/player/spells/fireball_spell.tscn")

export(int) var speed
export(int) var wall_impulse
export(int) var wall_gravity
export(int) var player_gravity
export(int) var jump_speed
export(int) var wall_jump_speed

var inventory: Array = []
var jump_count: int = 0
var velocity: Vector2
var spell_offset: Vector2 = Vector2(100, -50)

#Flags
var landing: bool = true
var on_hit: bool = false
var dead: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var wall_sliding: bool = false
var not_on_wall: bool = true
var can_track_input: bool = true
var light_on = false
var wall_direction: int = 1



func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	player_sprite.animate(velocity)
	gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if !can_track_input or attacking:
		velocity.x = 0
		return
		
	velocity.x = input_direction*speed

func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall_slide():
		jump_count = 0
	
	var jump_condition: bool = can_track_input and not attacking
	if Input.is_action_just_pressed("jump") and jump_count<2 and jump_condition:
		velocity.y = 0
		jump_count += 1
		if is_on_wall_slide():
			velocity.y -= wall_jump_speed
			velocity.x += wall_impulse*wall_direction
		else: 
			spawn_effect("res://scenes/env/effects/jump.tscn", Vector2(0, 18), player_sprite.flip_h, false)
			velocity.y -= jump_speed
			
func is_on_wall_slide() -> bool:
	if get_node("WallRay").is_colliding() and not is_on_floor():
		wall_sliding = true
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
		return true
	
	wall_sliding = false
	not_on_wall = true
	return false
		


func actions_env() -> void:
	attack()
	crouch()
	defense()

func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending and is_on_floor()
	if attack_condition:
		if Input.is_action_just_pressed("attack"):
			attacking = true
			player_sprite.normal_attack = true
			
		elif Input.is_action_just_pressed("spell") and stats.current_mana>=stats.spell_mana_cost:
			attacking = true
			player_sprite.magic_attack = true

func magic_attack() -> void:
	stats.update_mana("Decrease", stats.spell_mana_cost)
	spawn_fireball()
	
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		stats.shielding = false
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player_sprite.crouching_off = true
	
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		can_track_input = false
		stats.shielding = true
	elif not crouching:
		defending = false
		can_track_input = true
		stats.shielding = false
		player_sprite.shield_off = true

func gravity(delta: float) -> void:
	if is_on_wall_slide():
		velocity.y += delta*wall_gravity
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
	else:
		velocity.y += delta*player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity

func spawn_effect(path: String, offset: Vector2, is_hflipped: bool, is_vflipped: bool) -> void:
	var instance: Effect = load(path).instance()
	get_tree().root.call_deferred("add_child", instance)
	if is_hflipped:
		instance.flip_h = true
		
	if is_vflipped:
		instance.flip_v = true
	instance.global_position = global_position+offset
	instance.play_effect()
	
	
func spawn_fireball():
	var instance: FireBall = FIREBALL.instance()
	instance.spell_damage = stats.base_magic_attack+stats.bonus_magic_attack
	instance.global_position = global_position+spell_offset
	get_tree().root.call_deferred("add_child", instance)


