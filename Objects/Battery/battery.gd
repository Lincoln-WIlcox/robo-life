extends Node2D

@export var unique_save_id: UniqueSaveId

@onready var collectable_save_component: CollectableSaveComponent = $CollectableSaveComponent
@onready var pickup_area: WalkOverItemPickupArea = $WalkOverItemPickupArea

func _on_walk_over_item_pickup_area_collected():
	collectable_save_component.set_collected(true)
	on_collected()

func _ready():
	$WalkOverItemPickupArea.inventory_addition = $WalkOverItemPickupArea.inventory_addition.duplicate()
	collectable_save_component.unique_save_id = unique_save_id
	
	if collectable_save_component.is_collected():
		on_collected()

func on_collected() -> void:
	pickup_area.set_deferred("monitorable", false)
	pickup_area.set_deferred("monitoring", false)
	hide()

func on_uncollected() -> void:
	pickup_area.set_deferred("monitorable", true)
	pickup_area.set_deferred("monitoring", true)
	show()

func _on_collectable_save_component_loading_collected_collectable():
	on_collected()

func _on_collectable_save_component_loading_uncollected_collectable():
	on_uncollected()
