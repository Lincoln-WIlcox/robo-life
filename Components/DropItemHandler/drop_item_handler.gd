extends Node

@export var player_character: PlayerCharacter
@export var item_spawner: ItemSpawner

signal drop_created(drop: Node)

func drop_item(item: ItemData):
	var drop_position: Vector2 = player_character.drop_item_left.global_position if player_character.facing_left else player_character.drop_item_right.global_position
	var drop: Node = item_spawner.drop_item_at(item, drop_position)
	drop_created.emit(drop)
