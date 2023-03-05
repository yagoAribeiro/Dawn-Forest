extends KinematicBody2D
class_name EnemyTemplate

#Consts
onready var texture:Sprite = get_node("Texture")
onready var floor_ray:RayCast2D = get_node("FloorRay")
onready var animation:AnimationPlayer = get_node("Animation")
onready var stats:Node = get_node("Stats")
onready var detection_area:Area2D = get_node("DetectionArea")
onready var item_scene: PackedScene = preload("res://scenes/item/physical_item.tscn")
onready var dice: Resource = preload("res://scenes/management/dice.tscn")
onready var drop_list: Array 
#Flags
var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false
var can_move: bool = true
var can_cancel: bool = false
var hitted: bool = false
var velocity: Vector2
var looking_back = false
var player_ref: Player = null
var last_direction: Vector2 = Vector2(1.0, 1.0)
var sorted_direction: bool = false
var dropped_itens: Array = []
#Vars
onready var speed = stats.speed
onready var chase_speed = stats.chase_speed
onready var gravity_speed = stats.gravity_speed
onready var proximity_threshold = stats.proximity_threshold
onready var raycast_default_position = stats.raycast_default_position
onready var detection_area_default_position = stats.detection_area_default_position

#States
enum move_state{PATROL, CHASE, DEAD}
var current_state = move_state.PATROL

func _physics_process(delta):
	gravity(delta)
	attack_behavior(delta)
	move_behavior(delta)
	verify_position()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
func gravity(delta: float) -> void:
	velocity.y += delta*gravity_speed

func attack_behavior(_delta: float) -> void:
	if player_ref!=null:
		var distance: Vector2 = player_ref.global_position - global_position
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true

func move_behavior(_delta: float) -> void:	
	if player_ref!=null:
		current_state = move_state.CHASE
	elif not can_attack:
		current_state = move_state.PATROL
	if can_move:	
		match(current_state):
			move_state.CHASE:
				sorted_direction = false
				if player_ref!=null:
					var distance: Vector2 = player_ref.global_position - global_position
					var direction: Vector2 = distance.normalized()
					last_direction = direction
					if floor_collision() and not can_attack:
						velocity.x = direction.x * chase_speed
					else:
						velocity.x = 0
				return
				
			move_state.PATROL: 
				sort_direction()
				if floor_collision():
					velocity.x = last_direction.x*speed
				else:
					velocity.x = 0
				return
	velocity.x = 0

func sort_direction() -> void:
	if sorted_direction!= true:
		var random: int = int(round(rand_range(1.0, 2.0)))
		if random == 2.0:
			last_direction.x = -1
		else:
			last_direction.x = 1
		sorted_direction = true

func look_back(look_back: bool = false) -> void:
	looking_back = look_back

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
		
	return false

func verify_position() -> void:
	var direction:float = 0
	if player_ref != null:
		direction = sign(player_ref.global_position.x - global_position.x)
	else:
		direction = last_direction.x
		
	if direction > 0:
		texture.flip_h = true
		floor_ray.position.x = abs(raycast_default_position)
		if looking_back:
			detection_area.position.x = detection_area_default_position*0.75
		else:	
			detection_area.position.x = abs(detection_area_default_position)
	elif direction < 0:
		texture.flip_h = false
		floor_ray.position.x = raycast_default_position
		if looking_back:
			detection_area.position.x = abs(detection_area_default_position)*0.75
		else:	
			detection_area.position.x = detection_area_default_position
			
func stop_move(stopped: bool) ->void:
	if stopped:
		can_move = false
	else: 
		can_move = true
		

func drop_item() -> void:
	var randomizer: Gacha = Gacha.new()
	dropped_itens = randomizer.gacha(drop_list)
	if dropped_itens.size()!=0:
		var dice_instance = dice.instance()
		get_tree().root.add_child(dice_instance)
		dice_instance.global_position = Vector2(global_position.x, global_position.y-40)
		dice_instance.start_timer(randomizer.d20result, self)	
				
func drop() -> void:
	for item in dropped_itens:
		var item_dropped: PhysicalItem = item_scene.instance()
		get_tree().root.call_deferred("add_child", item_dropped)
		item_dropped.get_data(item["name"])
		item_dropped.spawn_item(global_position)

