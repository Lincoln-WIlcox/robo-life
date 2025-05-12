class_name Utils
extends RefCounted

const MINIMUM_SPEED = 0.2
const TIME_PASSED_AT_NIGHT = 50
const HIGHEST_LADDER_OFFSET = 5
const ITEM_GRID_TILE_SIZE = 48
const AMOUNT_OF_FOOD_TO_CONSUME = 10
const POINTS_SIMILAR_MARGIN = 0.05
const SECTOR_SIZE = Vector2(512, 512)

#ordered such that it's easy to work with angle math.
enum DIRECTIONS
{
	RIGHT = 0,
	DOWN,
	LEFT,
	UP
}

enum QUADRANTS
{
	UPPER_LEFT = 0,
	UPPER_RIGHT,
	LOWER_RIGHT,
	LOWER_LEFT
}

enum GrabDirections
{
	LEFT = 1,
	RIGHT
}

enum COLLISION_LAYERS
{
	Ground = 1,
	OneWayPlatforms,
	Entities,
	WalkThroughEntities,
	MouseDetector,
	Damage,
	Heat,
	IntangibleEnvironmentObjects,
	ItemGridTiles,
	Player,
	Power
}

#used for the return of get_point_along_polygon_and_vertex_closest_to_point
enum POINT_ALONG_POLYGON_RETURN_DICTIONARY_KEYS
{
	CLOSEST_POINT,
	CLOSEST_VERTEX_INDEX
}

#used for the return of get_point_along_polygon_and_vertex_closest_to_point in res://Characters/Enemies/NightRobot/find_closest_point.gd
enum IS_CLOCKWISE_SHORTER_RETURN_DICTIONARY_KEYS
{
	CLOCKWISE_SHORTER,
	CLOSEST_POINT_TO_TARGET
}

#used for map entities to store what type of maps they should be in. Mapdata and map display are not concerned about this, this is purely for the logic of deciding what entities to put into map data.
#enum MAPS
#{
	#MAP
#}

##Removes duplicates from the array.
static func make_array_unique(array: Array) -> Array:
	var unique: Array = []
	
	for item in array:
		if not unique.has(item):
			unique.append(item)
	
	return unique

##Used by inventories to determine which tile a move tile is hovering over.
static func get_placing_tile(move_tile: MoveTileArea):
	var item_grid_tile_areas: Array[Area2D] = move_tile.get_overlapping_areas().filter(func(a: Area2D): return a is ItemGridTileArea)
	
	var first_tile = null
	for tile_area: ItemGridTileArea in item_grid_tile_areas:
		if first_tile != null and tile_area.item_grid_tile is ItemGridEmptyTile:
			first_tile = tile_area.item_grid_tile if tile_area.item_grid_tile.global_position.distance_to(move_tile.global_position) < first_tile.global_position.distance_to(move_tile.global_position) else first_tile
		elif tile_area.item_grid_tile is ItemGridEmptyTile:
			first_tile = tile_area.item_grid_tile
	
	return first_tile

##Converts an angle in radians to an index in the DIRECTIONS enum.
static func convert_angle_to_dir_index(angle: float, diagonal_offset = 0.1) -> int:
	var using_angle = angle + (diagonal_offset if angle_is_diagonal(angle) else 0.0)
	#gets how far around a circle the angle is from 0 to 1, multiplies by 4 and then rounds. then modulos to shrink high or low angles
	var step_one = roundi(using_angle / TAU * DIRECTIONS.size()) % DIRECTIONS.size()
	#adds the full amount and modulos again to make negative indexes positive
	var step_two = (step_one + DIRECTIONS.size()) % DIRECTIONS.size()
	return step_two

##Returns true if an angle is diagonal.
static func angle_is_diagonal(angle: float) -> bool:
	var int_angle = roundi(rad_to_deg(angle))
	return int_angle % 45 == 0 && not angle_is_orthogonal(int_angle)

##Returns true if an angle is orthogonal.
static func angle_is_orthogonal(angle: float) -> bool:
	var int_angle = roundi(rad_to_deg(angle))
	return int_angle % 90 == 0

static func tile_data_has_collision(tile_data: TileData, collision_layer = 0):
	return tile_data.get_collision_polygons_count(collision_layer) > 0

##Returns all the tiles with collision that are connected to the tile at tile_pos. 
static func get_touching_tiles_with_collision(tile_map_layer: TileMapLayer, tile_pos: Vector2i, collision_layer: int = 0, exclude: Array[Vector2i] = []) -> Array[Vector2i]:
	var tile: TileData = tile_map_layer.get_cell_tile_data(tile_pos)
	var tile_has_collision: bool = tile.get_collision_polygons_count(collision_layer) > 0 if tile else false
	
	if tile_has_collision:
		var surrounding_tiles_pos: Array[Vector2i] = tile_map_layer.get_surrounding_cells(tile_pos)
		
		if not exclude.has(tile_pos):
			exclude.append(tile_pos)
		
		var new_tiles: Array[Vector2i] = [tile_pos]
		for checking_tile_pos: Vector2i in surrounding_tiles_pos:
			if not exclude.has(checking_tile_pos) and tile_map_layer.get_used_rect().has_point(checking_tile_pos):
				new_tiles.append_array(get_touching_tiles_with_collision(tile_map_layer, checking_tile_pos, collision_layer, exclude))
		
		return new_tiles
	
	return []

##Finds the point along the polygon closest to the given point. It will only return a point on the perimeter, even if the point is inside the polygon.
static func get_point_along_polygon_closest_to_point(polygon: PackedVector2Array, point: Vector2) -> Vector2: 
	var closest_point_along_wall: Vector2 = polygon[0]
	
	for i: int in range(polygon.size()):
		var starting_point = polygon[i]
		var ending_point = polygon[(i + 1 if i < polygon.size() - 1 else 0)]
		
		var closest_point_on_segment = Geometry2D.get_closest_point_to_segment(point, starting_point, ending_point)
		
		if closest_point_on_segment.distance_to(point) < closest_point_along_wall.distance_to(point):
			closest_point_along_wall = closest_point_on_segment
	
	return closest_point_along_wall

##Finds the index of the vertex in polygon that is closest to the given point.
static func get_closest_vertex_index_to_point(polygon: PackedVector2Array, point: Vector2) -> int:
	var closest_vertex_index: int = 0
	
	for i: int in range(polygon.size()):
		if polygon[i].distance_to(point) < polygon[closest_vertex_index].distance_to(point):
			closest_vertex_index = i
	
	return closest_vertex_index

##Finds the point along the polygon closest to the given point and the index of the vertex before the closest point. It will only return a point along the perimeter, even if the point is inside the polygon.
##Combines the get_point_along_polygon_closest_to_point and get_closest_vertex_index_to_point functions for more efficiency, as this is a somewhat costly function.
##The closest vertex will be clockwise of the closest point if the polygon is counterclockwise, and vice versa.
static func get_point_along_polygon_and_vertex_closest_to_point(polygon: PackedVector2Array, point: Vector2) -> Dictionary: 
	var closest_point_along_wall: Vector2 = polygon[0]
	var closest_vertex_index: int = 0
	
	for i: int in range(polygon.size()):
		var starting_point = polygon[i]
		var ending_point = polygon[(i + 1 if i < polygon.size() - 1 else 0)]
		
		var closest_point_on_segment = Geometry2D.get_closest_point_to_segment(point, starting_point, ending_point)
		
		if closest_point_on_segment.distance_to(point) < closest_point_along_wall.distance_to(point):
			closest_point_along_wall = closest_point_on_segment
			closest_vertex_index = i
	
	return {POINT_ALONG_POLYGON_RETURN_DICTIONARY_KEYS.CLOSEST_POINT: closest_point_along_wall,POINT_ALONG_POLYGON_RETURN_DICTIONARY_KEYS.CLOSEST_VERTEX_INDEX: closest_vertex_index}

##Finds the next vertex along the polygon in the given direction from the point on the polygon closest to the given point. Assumes polygon is counter-clockwise. If polygon is clockwise, return will by inverted.
static func get_next_vertex_in_direction(polygon: PackedVector2Array, point: Vector2, clockwise: bool) -> int:
	var closest_point_along_wall: Vector2 = get_point_along_polygon_closest_to_point(polygon, point)
	
	for i: int in range(polygon.size()):
		var starting_point = polygon[i]
		var next_index = i + 1 if i < polygon.size() - 1 else 0
		var ending_point = polygon[next_index]
		
		var closest_point_on_segment = Geometry2D.get_closest_point_to_segment(point, starting_point, ending_point)
		if (closest_point_on_segment - closest_point_along_wall).length() <= POINTS_SIMILAR_MARGIN:
			return i if clockwise else next_index
	
	return 0

##Will merge an array of polygons into one polygon. This will ignore any holes inside the polygons or polygons that aren't overlapping, returning only the outermost perimeter. 
##It will exclude polygons that are only touching at points; polygons need to be overlapping or share an edge segment to be merged.
static func merge_polygons_to_one(merging_polygons: Array[PackedVector2Array]) -> PackedVector2Array:
	var total_polygon: PackedVector2Array = merging_polygons[0]
	merging_polygons.remove_at(0)
	
	for polygon: PackedVector2Array in merging_polygons:
		var merged_polygons: Array[PackedVector2Array] = Geometry2D.merge_polygons(total_polygon, polygon)
		for merged_polygon: PackedVector2Array in merged_polygons:
			if not Geometry2D.is_polygon_clockwise(merged_polygon):
				total_polygon = merged_polygon
				break
	
	return total_polygon

##Merges all polygons in [param merging_polygons] and returns the merged polygons.
static func merge_polygons(merging_polygons: Array[PackedVector2Array]) -> Array[PackedVector2Array]:
	var merged_polygons: Array[PackedVector2Array] = merging_polygons.duplicate()
	var polygons_were_merged: bool = true
	
	while(polygons_were_merged):
		var new_merged_polygons: Array[PackedVector2Array] = []
		polygons_were_merged = false
		
		for merging_polygon_index: int in merged_polygons.size():
			var merging_polygon: PackedVector2Array = merged_polygons[merging_polygon_index]
			
			for merging_polygon_subindex in merging_polygon_index:
				if new_merged_polygons.has(merged_polygons[merging_polygon_subindex]):
					continue
				
				var other_merging_polygon: PackedVector2Array = merged_polygons[merging_polygon_subindex]
				
				var merged_polygon: Array[PackedVector2Array] = Geometry2D.merge_polygons(merging_polygon, other_merging_polygon)
				
				#if the polygons were merged, the size of the array will be 1. in other words, if the polygons were not overlapping, continue.
				if merged_polygon.size() != 1:
					new_merged_polygons.append_array(merged_polygon)
					continue
				
				new_merged_polygons.append(merged_polygon[0])
				polygons_were_merged = true
				
				break
		
		merged_polygons = new_merged_polygons
	
	return merged_polygons

##Intersects all polygons in [param intersecting_polygons] and returns the intersected polygons (keeps area shared by all polygons).
static func intersect_polygons(intersecting_polygons: Array[PackedVector2Array]) -> Array[PackedVector2Array]:
	var intersected_polygons: Array[PackedVector2Array]
	
	return []

##Intersects polygon arrays in [param intersecting_polygon_arrays] and returns the intersected polygons. Only area shared by all polygon arrays are kept.
##Arrays within [param intersecting_polygon_arrays] must be of type Array[PackedVector2Array].
static func intersect_multiple_polygon_arrays(intersecting_polygon_arrays: Array[Array]) -> Array[PackedVector2Array]:
	for polygon_array: Array in intersecting_polygon_arrays:
		assert(polygon_array is Array[PackedVector2Array], "Arrays within intersecting_polygon_arrays must be of type Array[PackedVector2Array].")
	
	if intersecting_polygon_arrays.size() == 1:
		return intersecting_polygon_arrays[0]
	
	var intersected_polygons: Array[PackedVector2Array]
	for polygons_a: Array[PackedVector2Array] in intersecting_polygon_arrays:
		var intersecting_polygon_arrays_excluding_a: Array[Array] = intersecting_polygon_arrays.duplicate()
		intersecting_polygon_arrays_excluding_a.erase(polygons_a)
		for polygons_b: Array[PackedVector2Array] in intersecting_polygon_arrays_excluding_a:
			var new_intersected_polygons = intersect_two_polygon_arrays(polygons_a, polygons_b)
			intersected_polygons.append_array(new_intersected_polygons)
	
	var merged_polygons = merge_polygons(intersected_polygons)
	
	return merged_polygons

##Intersects polygons in [param polygon_array_a] and [param polygon_array_b] and returns the intersected polygons. Only area shared by each array of polygons is kept.
static func intersect_two_polygon_arrays(polygon_array_a: Array[PackedVector2Array], polygon_array_b: Array[PackedVector2Array]) -> Array[PackedVector2Array]:
	var intersected_polygons: Array[PackedVector2Array]
	
	for polygon_a: PackedVector2Array in polygon_array_a:
		for polygon_b: PackedVector2Array in polygon_array_b:
			var new_intersected_polygons: Array[PackedVector2Array] = Geometry2D.intersect_polygons(polygon_a, polygon_b)
			intersected_polygons.append_array(new_intersected_polygons)
	
	var merged_polygons = merge_polygons(intersected_polygons)
	
	return merged_polygons

##Merges touching polygons in array. Returns an array of the merged polygons.
static func merge_touching_polygons(collision_polygons: Array[PackedVector2Array]) -> Array[PackedVector2Array]:
	var merged_touching_polygons: Array[PackedVector2Array]
	
	for polygon_a: PackedVector2Array in collision_polygons:
		for polygon_b: PackedVector2Array in collision_polygons:
			var merged_polygons: Array[PackedVector2Array] = Geometry2D.merge_polygons(polygon_a, polygon_b)
			merged_touching_polygons.append_array(merged_polygons)
	
	return merged_touching_polygons

##Assumes the collider is a TileMapLayer. Check if the collider is a TileMapLayer before passing.
static func get_colliding_tile_position(collision: KinematicCollision2D) -> Vector2i:
	var tile_map_layer = collision.get_collider()
	assert(tile_map_layer is TileMapLayer, "not colliding with a tilemap. Check if the collider is a tilemap before using this function.")
	
	var collision_position: Vector2 = collision.get_position()
	collision_position = tile_map_layer.to_local(collision_position)
	collision_position = collision_position - collision.get_normal()
	var tile_pos: Vector2i = tile_map_layer.local_to_map(collision_position)
	return tile_pos

##Returns tile data at the position local to tile_map.
static func get_tile_data_at_local_position(tile_map: TileMapLayer, at_position: Vector2) -> TileData:
	var tile_pos = tile_map.local_to_map(at_position)
	return tile_map.get_cell_tile_data(tile_pos)

static func total_distance_along_path(path: PackedVector2Array) -> float:
	var total_distance: float = 0
	
	#minus 1 because we don't have to add the distance between the final vertex and any other vertex; just the vertices in between.
	for i: int in range(path.size()-1):
		total_distance += path[i].distance_to(path[i + 1])
	
	return total_distance

##Acts as a normal slice if from is less than to, but if from is greater than to then it gets the values from from up and to down.
##This still excludes to, so if to is 0 it won't include 0, and if to is 1 it will only include 0 and not 1.
static func wrap_around_slice(array: Array, from: int, to: int, wrap_around_if_same: bool = false) -> Array:
	var return_array
	
	if from > to or from == to and wrap_around_if_same:
		return_array = array.slice(from)
		return_array.append_array(array.slice(0, to))
	else:
		return_array = array.slice(from, to)
	
	return return_array

##Returns the quadrant given point is in. Check against QUADRANTS enum.
##If X is zero, it will return as right, and if Y is zero is will return as down.
static func get_quadrant_of_point(point: Vector2) -> int:
	if point.x < 0:
		if point.y < 0:
			return QUADRANTS.UPPER_LEFT
		else:
			return QUADRANTS.LOWER_LEFT
	else:
		if point.y < 0:
			return QUADRANTS.UPPER_RIGHT
		else:
			return QUADRANTS.LOWER_RIGHT

##Returns the quadrant given angle is in. Check against QUADRANTS enum.
static func get_quadrant_of_angle(angle: float) -> int:
	var point := Vector2(1, 0).rotated(angle)
	return get_quadrant_of_point(point)

static func quadrant_to_diagonal_angle(quadrant: int) -> float:
	match(quadrant):
		QUADRANTS.UPPER_LEFT:
			return deg_to_rad(-135)
		QUADRANTS.UPPER_RIGHT:
			return deg_to_rad(-45)
		QUADRANTS.LOWER_RIGHT:
			return deg_to_rad(45)
		QUADRANTS.LOWER_LEFT:
			return deg_to_rad(135)
	printerr("value " + str(quadrant) + " is not a quadrant.")
	return 0

static func packed_vector_array_to_polygon(packed_vector_array: PackedVector2Array) -> Polygon2D:
	var polygon: Polygon2D = Polygon2D.new()
	polygon.polygon = packed_vector_array
	return polygon

static func packed_vector_arrays_to_polygons(packed_vector_arrays: Array[PackedVector2Array]) -> Array[Polygon2D]:
	var polygons: Array[Polygon2D]
	for packed_vector_array: PackedVector2Array in packed_vector_arrays:
		var polygon = packed_vector_array_to_polygon(packed_vector_array)
		polygons.append(polygon)
	return polygons

static func add_children(adding_to_node: Node, nodes_to_add: Array[Node]) -> void:
	for child: Node in nodes_to_add:
		adding_to_node.add_child(child)

static func get_normalized_delta_time() -> float:
	return 1.0 / float(Engine.max_fps)

static func float_per_frame_to_float_per_time(value: float, delta: float) -> float:
	return value * delta / get_normalized_delta_time()

static func get_index_of_point_along_curve_before_offset(curve: Curve2D, offset: float) -> int:
	var curve_copy: Curve2D = curve.duplicate()
	
	while curve_copy.get_baked_length() > offset:
		curve_copy.remove_point(curve_copy.point_count - 1)
	
	return curve_copy.point_count - 1

static func get_offset_of_point_along_curve(curve: Curve2D, point_index: int) -> float:
	var curve_copy: Curve2D = curve.duplicate()
	
	while curve_copy.point_count - 1 > point_index:
		curve_copy.remove_point(curve_copy.point_count - 1)
	
	return curve_copy.get_baked_length()

#sector coords is the coords of the sector on the sector grid where one unit is one sector.
static func get_global_sector_bounds(sector_coords: Vector2i) -> Rect2:
	return Rect2(Vector2(sector_coords) * SECTOR_SIZE, SECTOR_SIZE)

static func get_sector_coords_at(at_position: Vector2) -> Vector2i:
	return Vector2i(floori(at_position.x / SECTOR_SIZE.x), floori(at_position.y / SECTOR_SIZE.y))

##Returns true if the transaction was successful.
static func handle_inventory_requirement_interaction_area_interaction(inventory: Inventory, inventory_requirement_interaction_area: InventoryRequirementInteractionArea, interactor: Object) -> bool:
	if inventory_requirement_interaction_area.disabled:
		return false
	if inventory.spend_requirement(inventory_requirement_interaction_area.inventory_requirement):
		inventory_requirement_interaction_area.meet_requirements(interactor)
		return true
	else:
		inventory_requirement_interaction_area.fail_requirements(interactor)
	return false

##Returns true if the given polygons overlap, including if one polygon is entirely inside another or they only touch boundaries.
static func polygons_overlap(a: PackedVector2Array, b: PackedVector2Array) -> bool:
	var iterating_polygon = a if a.size() < b.size() else b
	var other_polygon = a if a != iterating_polygon else b
	for point: Vector2 in iterating_polygon:
		if Geometry2D.is_point_in_polygon(point, other_polygon):
			return true
	return false

##Returns the bounding box of the given polygon.
static func get_polygon_bounding_box(polygon: PackedVector2Array) -> Rect2:
	var top_left: Vector2 = Vector2(polygon[0].x, polygon[0].y)
	var bottom_right: Vector2 = Vector2(polygon[0].x, polygon[0].y)
	
	for point: Vector2 in polygon:
		top_left = top_left.min(point)
		bottom_right = bottom_right.max(point)
	
	return Rect2(top_left, bottom_right - top_left)

##Returns true if [param inside_polygon] is entirely inside [outside_polygon]. 
static func polygon_inside_polygon(outside_polygon: PackedVector2Array, inside_polygon: PackedVector2Array) -> bool:
	for point: Vector2 in inside_polygon:
		if not Geometry2D.is_point_in_polygon(point, outside_polygon):
			return false
	return true

##Clips each polygon in [param clipping_polygons] with [param against_polygon] and returns the clipped polygons.
static func clip_polygons(clipping_polygons: Array[PackedVector2Array], against_polygon: PackedVector2Array) -> Array[PackedVector2Array]:
	var clipped_polygons: Array[PackedVector2Array] = []
	for clipping_polygon: PackedVector2Array in clipping_polygons:
		if Utils.polygons_overlap(clipping_polygon, against_polygon):
			clipped_polygons.append_array(Geometry2D.clip_polygons(clipping_polygon, against_polygon))
		else:
			clipped_polygons.append(clipping_polygon)
	
	return clipped_polygons

##Clips [param clipping_polygon] with each of [param against_polygons] and returns the clipped polygons. Assumes no polygons in [param against_polygons] overlap.
static func clip_polygon_with_polygons(clipping_polygon: PackedVector2Array, against_polygons: Array[PackedVector2Array]) -> Array[PackedVector2Array]:
	var clipped_polygons: Array[Array] = []
	
	for against_polygon: PackedVector2Array in against_polygons:
		var new_clipped_polygons: Array[PackedVector2Array] = Geometry2D.clip_polygons(clipping_polygon, against_polygon)
		clipped_polygons.append(new_clipped_polygons)
	
	var intersected_polygons: Array[PackedVector2Array] = intersect_multiple_polygon_arrays(clipped_polygons)
	
	return intersected_polygons

##Converts given [Rect2] to a [RectangleShape2D].
static func rect2_to_shape(rect2: Rect2) -> RectangleShape2D:
	var shape = RectangleShape2D.new()
	shape.shape.size = rect2.size
	shape.transform = rect2.position
	return shape

##Returns true if [param array] has each element in [each]
static func array_has_each(array: Array, each: Array) -> bool:
	for element in each:
		if not array.has(element):
			return false
	return true

static func set_bit(bit_flags: int, bit: int) -> int:
	return bit_flags | bit

static func unset_bit(bit_flags: int, bit: int) -> int:
	return bit_flags & ~bit

static func is_bit_set(bit_flags: int, bit: int) -> bool:
	return (bit_flags & bit) != 0

static func free_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()

static func get_in_array_wrap(array: Array, index: int) -> Variant:
	return array[(index % array.size() + array.size()) % array.size()]

static func vectors_weighted_combination(vectors: Array[Vector2], weights: Array[float]) -> Vector2:
	assert(vectors.size() == weights.size(), "Vectors and weights must have the same length.")
	
	var weighted_sum = Vector2.ZERO
	
	for i in range(vectors.size()):
		var weight = weights[i]
		weighted_sum += vectors[i] * weight
	
	return weighted_sum
