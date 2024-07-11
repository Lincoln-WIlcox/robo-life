extends Node

@export var player_character: PlayerCharacter
@export var item_pickup_scene: PackedScene

signal drop_created(drop: Object)

func drop_item(item: ItemData, position: Vector2):
	
	var drop
	if item.drop_scene:
		drop = load(item.drop_scene).instantiate()
	else:
		drop = item_pickup_scene.instantiate()
		drop.item = item
	
	drop.global_position = player_character.drop_item_left.global_position if player_character.facing_left else player_character.drop_item_right.global_position
	drop_created.emit(drop)
