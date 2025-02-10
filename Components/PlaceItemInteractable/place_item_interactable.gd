class_name PlaceItemInteractable
extends Node2D

@onready var interaction_area: InventoryRequirementInteractionArea = $InventoryRequirementInteractionArea

@export var accepts_item: ItemData
@export var node_to_put_item_pickup_in: Node2D
@export var item_pickup_packed_scene: PackedScene

var _item_placed: bool = false

signal item_placed
signal item_picked_up

func _ready():
	for collision_shape: Node in get_children():
		if collision_shape is CollisionShape2D:
			remove_child(collision_shape)
			interaction_area.add_child(collision_shape)
	
	interaction_area.inventory_requirement.costs_items.append(accepts_item)

func _on_inventory_requirement_interaction_area_requirements_met(_interactor):
	interaction_area.disabled = true
	_item_placed = true
	item_placed.emit()
	_create_item_pickup()

func _create_item_pickup():
	var item_pickup: ItemPickup = item_pickup_packed_scene.instantiate()
	item_pickup.item = accepts_item
	item_pickup.collected.connect(_on_item_pickup_collected)
	node_to_put_item_pickup_in.add_child(item_pickup)

func _on_item_pickup_collected(_item, _collector):
	interaction_area.disabled = false
	_item_placed = false
	item_picked_up.emit()
