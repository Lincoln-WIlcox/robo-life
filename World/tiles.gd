@tool
extends TileMapLayer

#@export var ledge_packed_scene: PackedScene
@export var one_way_platform_packed_scene: PackedScene
@export var environment_query_system: EnvironmentQuerySystem
@export_tool_button("Bake Ledges", "Callable") var bake_ledges_action = _bake_ledges

@onready var ledge_baker: LedgeBaker = $LedgeBaker

func _bake_ledges() -> void:
	ledge_baker.bake_ledges(self)
	pass

func _ready():
	if Engine.is_editor_hint():
		return
	
	for tile_position: Vector2 in get_used_cells():
		var tile: TileData = get_cell_tile_data(tile_position)
		if tile:
			#var ledge_bitflags = tile.get_custom_data("Ledge")
			var is_oneway = tile.get_custom_data("OneWay")
			#if ledge_bitflags != 0:
				#_apply_ledge(tile_position, ledge_bitflags)
			if is_oneway:
				_apply_one_way(tile_position)

#func _apply_ledge(tile_position: Vector2i, ledge_bitflags: int):
	#var local_position: Vector2 = map_to_local(tile_position)
	#if ledge_bitflags & Utils.GrabDirections.LEFT:
		#var tile_left = get_cell_tile_data(Vector2i(tile_position.x - 1, tile_position.y))
		#var tile_up = get_cell_tile_data(Vector2i(tile_position.x, tile_position.y - 1))
		#if tile_left == null and tile_up == null:
			#var ledge: Ledge = ledge_packed_scene.instantiate()
			#ledge.position = Vector2(local_position.x - 8,local_position.y - 8)
			#ledge.grab_direction = Utils.GrabDirections.LEFT
			#add_child(ledge)
	#if ledge_bitflags & Utils.GrabDirections.RIGHT:
		#var tile_right = get_cell_tile_data(Vector2i(tile_position.x + 1, tile_position.y))
		#var tile_up = get_cell_tile_data(Vector2i(tile_position.x, tile_position.y - 1))
		#if tile_right == null and tile_up == null:
			#var ledge: Ledge = ledge_packed_scene.instantiate()
			#ledge.position = Vector2(local_position.x + 8,local_position.y - 8)
			#ledge.grab_direction = Utils.GrabDirections.RIGHT
			#add_child(ledge)

func _apply_one_way(tile_position):
	var local_position: Vector2 = map_to_local(tile_position)
	var one_way_platform: StaticBody2D = one_way_platform_packed_scene.instantiate()
	one_way_platform.position = local_position
	if environment_query_system:
		environment_query_system.add_solid_entity_body(one_way_platform)
	add_child(one_way_platform)
