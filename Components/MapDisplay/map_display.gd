class_name MapDisplay
extends Control

const MAP_BOX_OFFSET = Vector2(10, 10)

@export var solidity_color: Color

@onready var map_view_handler: Node = $MapViewHandler
@onready var node_to_put_map_in: Node2D = $MapMargin/MapPanel/MapPadding/MapContainer/ScrollableContainer

func _display_polygons(packed_vectors: Array[PackedVector2Array]) -> void:
	var polygons: Array[Polygon2D] = Utils.packed_vector_arrays_to_polygons(packed_vectors)
	for polygon: Polygon2D in polygons:
		polygon.color = solidity_color
	var polygons_assigned: Array[Node]
	polygons_assigned.assign(polygons)
	Utils.add_children(node_to_put_map_in, polygons_assigned)

func _display_map_entities(map_entities: Array[MapEntity]) -> void:
	for map_entity: MapEntity in map_entities:
		if map_entity is MapTexture:
			_display_map_texture(map_entity)

func _display_map_texture(map_texture: MapTexture) -> void:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = map_texture.display_texture
	sprite.global_position = map_texture.get_position.call()
	sprite.z_index = map_texture.z_index
	sprite.scale = map_texture.scale
	node_to_put_map_in.add_child(sprite)

func _add_corner_markers(bounding_box: Rect2) -> void:
	var upper_left_marker = Node2D.new()
	upper_left_marker.position = bounding_box.position - MAP_BOX_OFFSET
	var lower_right_marker = Node2D.new()
	lower_right_marker.position = bounding_box.end + MAP_BOX_OFFSET
	
	node_to_put_map_in.add_child(upper_left_marker)
	node_to_put_map_in.add_child(lower_right_marker)
	
	map_view_handler.upper_left_marker = upper_left_marker
	map_view_handler.lower_right_marker = lower_right_marker

func clear_map() -> void:
	for node in node_to_put_map_in.get_children():
		node.queue_free() 

func display_map_data(map_data: MapData) -> void:
	clear_map()
	_display_polygons(map_data.get_tilemap_polygons())
	_display_map_entities(map_data.get_map_entities())
	_add_corner_markers(map_data.get_bounding_box())
