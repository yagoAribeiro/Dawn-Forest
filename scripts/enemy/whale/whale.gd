extends EnemyTemplate

class_name Whale

var detection_area_default_position:float = -110
#Flags
var looking_back = false

func _ready():
	drop_list = [
	#Ordem de raridade decrescente
	{"name": "Whale Tail", "id": 4, "chance": 25.0},
	{"name": "Whale Eye", "id": 3, "chance": 25.0},
	{"name": "Whale Mouth", "id": 5, "chance": 25.0},
	{"name": "Health Potion", "id": 0, "chance": 15.0},
	{"name": "Mana Potion", "id": 1, "chance": 15.0},
	{"name": "Super Mana Potion", "id": 10, "chance": 3.0},
	{"name": "Whale Mask", "id": 2, "chance": 1.5}
]
	


func look_back(look_back: bool = false) -> void:
	looking_back = look_back
	
func direction_process(_direction: float)->void:
	if _direction==1.0:
		detection_area.position.x = abs(detection_area_default_position) if not looking_back else detection_area_default_position*0.75
	elif _direction==-1.0:
		detection_area.position.x = detection_area_default_position if not looking_back else abs(detection_area_default_position*0.75)

