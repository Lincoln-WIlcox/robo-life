extends Node

@export var steel_mine: SteelMine
@export var power_supply: PowerSupply

func _ready():
	if not steel_mine.is_node_ready():
		await steel_mine.ready
	if not power_supply.is_node_ready():
		await power_supply.ready
	
	PowerConnectionHandler.add_connection(steel_mine.power_consumer, power_supply.power_connector)
