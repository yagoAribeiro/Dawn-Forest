extends CanvasModulate
class_name Mask

export(float, 10, 200) var day_duration
export(bool)var cycle_enabled:bool = true
export(Array, Dictionary) var cycles: Array = [
		{"color": Color(1,1,1), "duration": 0.30, "name":"day"},
		{"color": Color(0.968627, 0.67451, 0.219608), "duration": 0.15, "name":"sunfall"},
		{"color": Color(0.12549, 0.14902, 0.188235), "duration": 0.45, "name":"night"},
		{"color": Color(0.992157, 1, 0.760784), "duration": 0.10, "name":"sunset"}
	]
enum Cycle{DAY, SUNFALL, NIGHT, SUNSET}
export(int, 0, 3) var current_cycle: int = Cycle.DAY
 
func _ready():
	for turn in cycles:
		if turn.duration<1:
			turn.duration*=day_duration
	
	for child in get_parent().get_children():
		#Procura todas as background layer no parent para poder aplicar a mesma node
		if child is ParallaxBackground and not child.find_node("Mask"):
			child.add_child(self.duplicate())
	color = cycles[current_cycle].color	
	if cycle_enabled:
		wait_cycle()

func transition() -> void:
	if cycle_enabled:
		get_node("Tween").remove_all()
		var next_cycle: int = current_cycle+1 if current_cycle+1<4 else 0
		get_node("Tween").interpolate_property(self, "color",
			 cycles[current_cycle].color, cycles[next_cycle].color,
			 cycles[current_cycle].duration*0.5, Tween.TRANS_LINEAR,
			 Tween.EASE_IN_OUT, 0)
		get_node("Tween").start()	

func wait_cycle() -> void:
	if cycle_enabled:
		get_node("wait_cycle").wait_time = cycles[current_cycle].duration*0.5
		get_node("wait_cycle").start()

func _on_Tween_tween_all_completed() -> void:
	current_cycle = current_cycle+1 if current_cycle+1<4 else 0
	wait_cycle()


func _on_wait_cycle_timeout():
	transition()
