extends EnemyTemplate

class_name PinkStar

func _ready():
	drop_list.add(ChanceInstance.new({"name":"Pink Star Mouth","id":15}, 35.0))
	drop_list.add(ChanceInstance.new({"name":"Health Potion","id":0}, 15.0))
	drop_list.add(ChanceInstance.new({"name":"Mana Potion","id":1}, 15.0))
	drop_list.add(ChanceInstance.new({"name":"Pink Star Belt","id":12}, 5.0))
	drop_list.add(ChanceInstance.new({"name":"Super Mana Potion","id":10}, 5.0))
	drop_list.add(ChanceInstance.new({"name":"Super Health Potion","id":11}, 5.0))
	drop_list.add(ChanceInstance.new({"name":"Pink Star Shield","id":14}, 2.0))
	drop_list.add(ChanceInstance.new({"name":"Pink Star Bow","id":13}, 2.0))
