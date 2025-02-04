class_name MapDisplay
extends Control

const MAP_BOX_OFFSET = Vector2(10, 10)

@export var solidity_color: Color
@export var test_map_data: MapData

@onready var map_view_handler: Node = $MapViewHandler
@onready var node_to_put_map_in: Node2D = $MapMargin/MapPanel/MapPadding/MapContainer/ScrollableContainer
@onready var fog: TileMapLayer = $MapMargin/MapPanel/MapPadding/MapContainer/ScrollableContainer/Fog
@onready var fog_handler: Node = $FogOfWarHandler

var _representing_map_data: MapData

signal map_entity_removed(removed_map_entity: MapEntity)
signal map_changed

func _ready():
	if test_map_data:
		display_map_data(test_map_data)

func clear_map() -> void:
	for node in node_to_put_map_in.get_children():
		if node != fog:
			node.queue_free()
	map_changed.emit()

func disconnect_map_data() -> void:
	if _representing_map_data:
		_representing_map_data.solidity_changed.disconnect(redraw_polygons)
		_representing_map_data.map_entity_added.disconnect(_on_map_entity_added)
		_representing_map_data.map_entity_removed.disconnect(_on_map_entity_removed)
	_representing_map_data = null
	map_changed.emit()

func redraw_polygons(new_polygons: Array[PackedVector2Array]) -> void:
	_clear_polygons()
	_display_polygons(new_polygons)
	map_changed.emit()

func display_map_data(map_data: MapData) -> void:
	clear_map()
	disconnect_map_data()
	
	map_data.solidity_changed.connect(redraw_polygons.bind(map_data.get_solidity_polygons()))
	map_data.map_entity_added.connect(_on_map_entity_added)
	map_data.map_entity_removed.connect(_on_map_entity_removed)
	
	_representing_map_data = map_data
	
	_display_polygons(map_data.get_solidity_polygons())
	_display_map_entities(map_data.get_map_entities())
	_add_corner_markers(map_data.get_bounding_box())
	
	fog_handler.create_fog(map_data.get_bounding_box().size)
	
	map_changed.emit()

func get_map_entity_representations() -> Array[Node]:
	return node_to_put_map_in.get_children().filter(func(child: Node): return not child is Polygon2D)

func _display_polygons(packed_vectors: Array[PackedVector2Array]) -> void:
	var polygons: Array[Polygon2D] = Utils.packed_vector_arrays_to_polygons(packed_vectors)
	for polygon: Polygon2D in polygons:
		polygon.color = solidity_color
	var polygons_assigned: Array[Node]
	polygons_assigned.assign(polygons)
	Utils.add_children(node_to_put_map_in, polygons_assigned)

func _display_map_entities(map_entities: Array[MapEntity]) -> void:
	for map_entity: MapEntity in map_entities:
		_display_map_entity(map_entity)

func _display_map_entity(map_entity: MapEntity) -> void:
	if map_entity is MapTexture:
		_display_map_texture(map_entity)
	elif map_entity is MapScene:
		_display_map_scene(map_entity)

func _display_map_texture(map_texture: MapTexture) -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	_apply_map_texture_to_sprite(map_texture, sprite)
	map_texture.update_sprite.connect(_apply_map_texture_to_sprite.bind(map_texture, sprite))
	node_to_put_map_in.add_child(sprite)
	map_entity_removed.connect(func(removed_map_entity: MapEntity):
		if removed_map_entity == map_texture:
			node_to_put_map_in.remove_child(sprite)
		)
	
	return sprite

func _display_map_scene(map_scene: MapScene) -> Node:
	if map_scene.instance == null:
		map_scene.setup_scene()
	node_to_put_map_in.add_child(map_scene.instance)
	map_entity_removed.connect(func(removed_map_entity: MapEntity):
		if removed_map_entity == map_scene:
			node_to_put_map_in.remove_child(map_scene.instance)
		)
	
	return map_scene.instance

func _apply_map_texture_to_sprite(map_texture: MapTexture, sprite: Sprite2D) -> void:
	sprite.texture = map_texture.display_texture
	sprite.position = map_texture.get_position.call()
	sprite.z_index = map_texture.z_index
	sprite.scale = map_texture.scale

func _add_corner_markers(bounding_box: Rect2) -> void:
	var upper_left_marker = Node2D.new()
	upper_left_marker.position = bounding_box.position - MAP_BOX_OFFSET
	var lower_right_marker = Node2D.new()
	lower_right_marker.position = bounding_box.end + MAP_BOX_OFFSET
	
	node_to_put_map_in.add_child(upper_left_marker)
	node_to_put_map_in.add_child(lower_right_marker)
	
	map_view_handler.upper_left_marker = upper_left_marker
	map_view_handler.lower_right_marker = lower_right_marker
	map_view_handler.clamp_scroll_to_markers()

func _clear_polygons() -> void:
	for node in node_to_put_map_in.get_children():
		if node is Polygon2D:
			node.queue_free() 

func _on_map_entity_added(map_entity: MapEntity) -> void:
	_display_map_entity(map_entity)
	map_changed.emit()

func _on_map_entity_removed(map_entity: MapEntity) -> void:
	map_entity_removed.emit(map_entity)
	map_changed.emit()
