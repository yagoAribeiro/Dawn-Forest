extends CanvasModulate
class_name DayCycle

export(float, 24.0, 10000.0) var cycle_duration = 24.0
export(float, 0.0, 24.0) var day_time = 0.0
export(bool)var stopped:bool = false
export(Array, Dictionary) var cycles: Array = [
		{"color": Color(0.992157, 1, 0.760784), "game_hours_time": 4, "name":"sunset"},
		{"color": Color(1,1,1), "game_hours_time": 11, "name":"day"},
		{"color": Color(0.968627, 0.67451, 0.219608), "game_hours_time": 16, "name":"sunfall"},
		{"color": Color(0.12549, 0.14902, 0.188235), "game_hours_time": 18, "name":"night"}
]
var in_game_hour_mark: float
var in_game_hours: float = 0
var gradient:Gradient = Gradient.new()
var instances: Array
func _ready():	
	in_game_hour_mark = cycle_duration/24
	gradient.set_color(0, cycles[3].color)
	gradient.set_color(1, cycles[3].color)
	print("Total day duration (minutes): ", int(round(cycle_duration/60)))
	
	for cycle in cycles:
		gradient.add_point(float(cycle.game_hours_time), cycle.color)
		
	gradient.add_point(24, cycles[3].color)

	for child in get_parent().get_children():
		#Procura todas as background layer no parent para poder aplicar a mesma node
		if child is ParallaxBackground:
			var new_modulate: CanvasModulate = CanvasModulate.new()
			child.add_child(new_modulate)
			instances.append(new_modulate)

func _process(delta: float):
	in_game_hour_mark = cycle_duration/24
	if in_game_hour_mark!=0:
		in_game_hours = day_time/in_game_hour_mark
	if day_time>=cycle_duration:
		day_time = 0
	if !stopped:
		day_time+=1*delta
	color = gradient.interpolate(in_game_hours)
	sync_procces()
	
func sync_procces() -> void:
	for instance in instances:
		if instance is CanvasModulate:
			instance.color = self.color

