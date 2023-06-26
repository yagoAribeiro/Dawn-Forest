extends ParallaxBackground
class_name Background

export(bool) var can_process:bool = false
export(Array, Dictionary) var layer_obj: Array = [
		{"layer_name": "under", "motion_offset": Vector2.ZERO, "scale":Vector2(1.0,1.0)},
		{"layer_name": "far_away", "motion_offset": Vector2.ZERO, "scale":Vector2(0.3,0.3)},
		{"layer_name": "middle", "motion_offset": Vector2.ZERO, "scale":Vector2(0.5,0.5)},
		{"layer_name": "close", "motion_offset": Vector2.ZERO, "scale":Vector2(0.8,0.8)},
	]
	
		
func _physics_process(delta: float):
	for child_index in get_child_count():
		if get_child(child_index) is ParallaxLayer:
			for object in layer_obj:
				if(get_child(child_index).name == object.layer_name):
					if can_process:
						get_child(child_index).motion_offset.x -= delta*object.motion_offset.x
					else:
						get_child(child_index).motion_scale.x = object.scale.x
	
