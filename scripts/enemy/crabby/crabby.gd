extends EnemyTemplate

class_name Crabby

func _ready():
	#Ordem de raridade decrescente
	drop_list.add(ChanceInstance.new({"name":"Crabby Eyes", "id":6}, 25.0))
	drop_list.add(ChanceInstance.new({"name":"Crabby Pincers", "id":9}, 25.0))
	drop_list.add(ChanceInstance.new({"name":"Health Potion", "id":0},15.0))
	drop_list.add(ChanceInstance.new({"name":"Mana Potion", "id":1},15.0))
	drop_list.add(ChanceInstance.new({"name":"Super Health Potion", "id":11},5.0))
	drop_list.add(ChanceInstance.new({"name":"Crabby Belt", "id":7},1.5))
	drop_list.add(ChanceInstance.new({"name":"Crabby Axe", "id":8},1.5))
	
	



