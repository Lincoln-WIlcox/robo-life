@tool
class_name ItemCollectInteractionArea
extends InteractionArea

@export var item: ItemData

signal collected(item: ItemData, collected_by: Object)

func collect_item(collector: Object):
	collected.emit(item, collector)
	return item
