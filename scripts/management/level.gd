extends Node2D
class_name Level


onready var player: KinematicBody2D = get_node("Player")
onready var day_cycle: CanvasModulate = get_node_or_null("DayCycle")
var daytime: float = 0

func _process(_delta):
	if day_cycle!=null:
		daytime = day_cycle.in_game_hours
	if daytime > 18.0 or daytime < 6.0:
		player.light_on = true
	else:
		player.light_on = false
		

func _ready() -> void:
	var _game_over: bool = player.get_node("Texture").connect("game_over", self, "on_game_over")
	
func on_game_over() -> void:
	var _reload: bool = get_tree().reload_current_scene()
