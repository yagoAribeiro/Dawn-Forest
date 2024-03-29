extends Utils
class_name Gacha

var d20result: int = 0

func gacha(drop_list: ChanceCollection, can_drop_null: bool = true) -> Array:
	if drop_list.get_instances().size()==0: return []
	#As chances serão trabalhadas de 1 à 1000, então os números precisam ser multiplicados por 10
	var rand_number: float = float(get_random(1, 1000))
	if not rand_number<=drop_list.get_instances()[0].chance*10:
		#drop_list[0] deve ser sempre o item mais comum, portanto, não há drops
		if can_drop_null:
			return []
		else:
			return [drop_list.get_instances()[0].get_instance_data()]
		
	var multiplier: int = d20_sorter()
	var dropped: Array = []
	
	for i in range(multiplier):
		var possible_drop: Array = []
		if i!=0:
			#Caso o multiplicador seja maior que 1, terá outros gachas adicionais
			rand_number = float(get_random(1, 1000))
			if not rand_number<=drop_list.get_instances()[0].chance*10:
				#No caso, se tiver multiplicador, sempre será garantido um item mais comum
				dropped.append(drop_list.get_instances()[0].get_instance_data())
				continue
				
		for item in drop_list.get_instances():
			if rand_number<=item.chance*10:
				#Para cada gacha, salve os itens possíveis de acordo com o valor
				possible_drop.append(item)
		#no final do round de gacha, adicione ao loot o item escolhido entre os itens possíveis
		dropped.append(return_dropped_in_list(possible_drop).get_instance_data())
		
	return dropped #loot
	

func return_dropped_in_list(drop_list: Array) -> ChanceInstance:
	var most_rare: ChanceInstance
	var same_chance_list: Array = []
	#Laço para verificar o item mais raro
	for item in drop_list:
		if same_chance_list.size()==0:
			most_rare = item
			continue
			
		if item.chance<most_rare.chance:
			most_rare = item
	
	#Laço para verificar se há itens com a mesma raridade do item mais raro					
	for item in drop_list:
		if item.chance==most_rare.chance:		
			same_chance_list.append(item)
			
	if same_chance_list.size()!=0:
		most_rare = same_chance_gacha(same_chance_list)		
	
	return most_rare
	
func same_chance_gacha(drop_list: Array) -> ChanceInstance:
	return drop_list[randi()%drop_list.size()]	

func d20_sorter() -> int:
	d20result = get_random(1, 20)
	if d20result>19:
		return 4
	elif d20result>=17:
		return 3
	elif d20result>=10:
		return 2
	else:
		return 1
		
