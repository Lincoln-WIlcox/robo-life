@tool
class_name ItemPickup
extends Node2D

@onready var item_collect_interaction_area: ItemCollectInteractionArea = $ItemCollectInteractionArea
@onready var sprite: Sprite2D = $Sprite2D

@export var item: ItemData:
	set(new_value):
		item = new_value
		if is_inside_tree():
			item_collect_interaction_area.item = new_value
			_update_sprite()

signal collected(item: ItemData, collector: Object)

func _ready():
	item_collect_interaction_area.item = item
	_update_sprite()

func _update_sprite():
	if item:
		sprite.texture = item.texture
	else:
		sprite.texture = null

func _on_item_collect_interaction_area_collected(item: ItemData, collected_by: Object):
	collected.emit(item, collected_by)
	queue_free()
