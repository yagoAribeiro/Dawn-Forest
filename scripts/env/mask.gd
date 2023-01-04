extends CanvasModulate
class_name Mask

export(float, 10, 200) var day_duration
export(bool)var menu_process
onready var cycles = [
		{"color": Color(1,1,1), "duration": day_duration*0.30, "name":"day"},
		{"color": Color(0.968627, 0.67451, 0.219608), "duration": day_duration*0.15, "name":"sunfall"},
		{"color": Color(0.12549, 0.14902, 0.188235), "duration": day_duration*0.45, "name":"night"},
		{"color": Color(0.992157, 1, 0.760784), "duration": day_duration*0.10, "name":"sunset"}
	]
enum Cycle{DAY, SUNFALL, NIGHT, SUNSET}
var current_cycle: int = Cycle.DAY
 
func _ready():
	if menu_process:
		get_node("Tween").interpolate_property(self, "color",
			 cycles[current_cycle].color, cycles[current_cycle+1].color,
			 cycles[current_cycle].duration, Tween.TRANS_LINEAR,
			 Tween.EASE_IN_OUT, 0)
		get_node("Tween").start()	


func _on_Tween_tween_all_completed() -> void:
	get_node("Tween").remove_all()
	current_cycle = current_cycle+1 if current_cycle+1<4 else 0
	var next_cycle: int = current_cycle+1 if current_cycle+1<4 else 0
	get_node("Tween").interpolate_property(self, "color",
			 cycles[current_cycle].color, cycles[next_cycle].color,
			 cycles[current_cycle].duration, Tween.TRANS_EXPO,
			 Tween.EASE_IN_OUT, 0)
	get_node("Tween").start()	
	
