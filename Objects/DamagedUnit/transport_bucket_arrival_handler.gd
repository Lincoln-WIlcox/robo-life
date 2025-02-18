extends Node

@export var interactor: Node
@export var place_item_interactable: PlaceItemInteractable

func _on_power_consumer_transport_bucket_arrived(transport_bucket: TransportBucket):
	var transport_bucket_inventory: Inventory = transport_bucket.get_inventory()
	
	Utils.handle_inventory_requirement_interaction_area_interaction(transport_bucket_inventory, place_item_interactable.interaction_area, interactor)
