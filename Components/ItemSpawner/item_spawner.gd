class_name ItemSpawner
extends Node2D

@export var node_to_put_drop_in: Node
@export var item_pickup_scene: PackedScene

signal drop_created(drop: Node)

func drop_item(item: ItemData):
	var drop = _create_drop(item)
	drop.global_position = global_position
	_add_drop(drop)

func drop_item_at(item: ItemData, at: Vector2) -> void:
	var drop = _create_drop(item)
	drop.global_position = at
	_add_drop(drop)

func _create_drop(item: ItemData) -> Node:
	var drop
	if item.drop_scene:
		drop = load(item.drop_scene).instantiate()
	else:
		drop = item_pickup_scene.instantiate()
		drop.item = item
	
	return drop

func _add_drop(drop: Node) -> void:
	node_to_put_drop_in.add_child(drop)
	drop_created.emit(drop)
