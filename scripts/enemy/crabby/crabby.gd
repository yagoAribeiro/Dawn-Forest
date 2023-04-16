extends EnemyTemplate

class_name Crabby

func _ready():
	drop_list = [
	#Ordem de raridade decrescente
	{"name": "Crabby Eyes", "id": 6, "chance": 25.0},
	{"name": "Crabby Pincers", "id": 9, "chance": 25.0},
	{"name": "Health Potion", "id": 0, "chance": 15.0},
	{"name": "Mana Potion", "id": 1, "chance": 15.0},
	{"name": "Super Health Potion", "id": 11, "chance": 5.0},
	{"name": "Crabby Belt", "id": 7, "chance": 1.5},
	{"name": "Crabby Axe", "id": 8, "chance": 1.5}
]



