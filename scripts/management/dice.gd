extends Node2D
class_name Dice
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var count: int = 0
var result: int = 0
var out: bool = false
signal wait_timer()
onready var texture: Sprite = get_node("Texture")
onready var timer: Timer = get_node("Timer")
onready var animation: AnimationPlayer = get_node("Animation")

func start_timer(dice_result: int, enemy):
	var _result_error:int = connect("wait_timer", enemy, "drop")
	result = dice_result
	timer.start()

func _on_Timer_timeout():
	if count<10:
		rng.randomize()
		count+=1
		texture.texture = load(str("res://dice/",rng.randi()%20+1,".png"))
	elif !out: time_out()

func time_out():
	out = true
	animation.play("end")
	texture.texture = load(str("res://dice/",result,".png"))
	emit_signal("wait_timer")

		
