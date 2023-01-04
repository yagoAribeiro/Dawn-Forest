extends ParallaxBackground
class_name Background

export(bool) var can_process = false
export(Array, int) var layer_speed

func _ready():
	if !can_process:
		set_physics_process(false)
		
func _physics_process(delta: float):
	for child_index in get_child_count():
		if get_child(child_index) is ParallaxLayer:
			get_child(child_index).motion_offset.x -= delta*layer_speed[child_index]
