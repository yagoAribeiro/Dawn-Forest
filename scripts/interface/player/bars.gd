extends Control

onready var health_bar: TextureProgress = get_node("HealthBarBackground/HealthBar")
onready var mana_bar: TextureProgress = get_node("ManaBarBackground/ManaBar")
onready var exp_bar: TextureProgress = get_node("ExpBarBackground/ExpBar")
onready var tween: Tween = get_node("Animation")

var current_health: int = 0
var current_mana: int = 0
var current_exp: int = 0
	
func init(health: int, mana: int, max_exp: int) -> void:
	health_bar.max_value = health
	health_bar.value = health
	current_health = health
	
	mana_bar.max_value = mana
	mana_bar.value = mana
	current_mana = mana
	
	exp_bar.max_value = max_exp
	exp_bar.value = 0
	current_exp = 0
	
func increase_max_value(type: String, max_value: int, value: int) -> void:
		match(type):
			"health":
				current_health = value
				health_bar.max_value = max_value
				update_value(type, value)
			"mana":
				current_mana = value
				mana_bar.max_value = max_value
				update_value(type, value)
			"exp":
				current_exp = value
				exp_bar.max_value = max_value
				reset_exp_bar(max_value, current_exp)

func reset_exp_bar(max_exp: int, value: int) -> void:
	exp_bar.value = value
	call_tween(exp_bar, 0, current_exp)

func update_value(type: String, new_value: int) -> void:
	match(type):
			"health":
				call_tween(health_bar, current_health, new_value)
				current_health = new_value
			"mana": 
				call_tween(mana_bar, current_mana, new_value)
				current_mana = new_value
			"exp":
				call_tween(exp_bar, current_exp, new_value)
				current_exp = new_value
				
func call_tween(bar: TextureProgress, initial_value: int, final_value: int)->void:
	var _tween_return: bool = tween.interpolate_property(bar,
	 "value",
	 initial_value,
	 final_value,
	 0.25,
	 Tween.TRANS_LINEAR )
	var _start: bool = tween.start()
