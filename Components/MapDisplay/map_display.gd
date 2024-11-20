class_name MapDisplay
extends Control

@onready var node_to_put_map_in: Node2D = $MapMargin/MapPanel/MapPadding/MapContainer/ScrollableContainer

func _display_polygons(packed_vectors: Array[PackedVector2Array]) -> void:
	print(packed_vectors)
	var polygons: Array[Polygon2D] = Utils.packed_vector_arrays_to_polygons(packed_vectors)
	var polygons_assigned: Array[Node]
	polygons_assigned.assign(polygons)
	Utils.add_children(node_to_put_map_in, polygons_assigned)

func _display_map_entities(map_entities: Array[MapEntity]) -> void:
	print(map_entities[0].global_position)
	var sprites: Array[Sprite2D]
	
	for map_entity: MapEntity in map_entities:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = map_entity.display_texture
		sprite.global_position = map_entity.global_position
		sprites.append(sprite)
	
	#necessary because you cannot pass sub-types of arrays as arguments. the function accepts Array[Node], so i have to pass that.
	var sprites_assigned: Array[Node]
	sprites_assigned.assign(sprites)
	Utils.add_children(node_to_put_map_in, sprites_assigned)

func clear_map() -> void:
	for node in node_to_put_map_in.get_children():
		node.queue_free() 

func display_map_data(map_data: MapData) -> void:
	clear_map()
	_display_polygons(map_data.get_tilemap_polygons())
	_display_map_entities(map_data.get_map_entities())
