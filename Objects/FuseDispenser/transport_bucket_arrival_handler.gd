extends Node

@export var inventory_requirement_interaction_area: InventoryRequirementInteractionArea
@export var interactor: Node

func _on_power_consumer_transport_bucket_arrived(transport_bucket: TransportBucket):
	var transport_bucket_inventory: Inventory = transport_bucket.get_inventory()
	
	Utils.handle_inventory_requirement_interaction_area_interaction(transport_bucket_inventory, inventory_requirement_interaction_area, interactor)
