class_name StackedPolygonContainer
extends StackedPolygon

##A polygon on the polygon stack with polygons contained within.

var _contains_polygons: Array[StackedPolygon]

##Adds [param new_polygon] to the stack if it is contained within the container's bounds and does not overlap another contained polygon. Returns false if new_polygon fails to be added.
func add_contained_polygon(new_polygon: StackedPolygon) -> bool:
	for new_point: Vector2 in new_polygon.bounds:
		if not Geometry2D.is_point_in_polygon(new_point, bounds):
			return false
	
	for contained_polygon: StackedPolygon in _contains_polygons:
		if Utils.polygons_overlap(contained_polygon.bounds, new_polygon.bounds):
			return false
	
	_update_contained_polygon_is_hole(new_polygon)
	_contains_polygons.append(new_polygon)
	
	return true

func get_contained_polygons() -> Array[StackedPolygon]:
	return _contains_polygons

##Used by the polygon stack.
func update_contained_polygons_is_hole() -> void:
	for contained_polygon: StackedPolygon in _contains_polygons:
		_update_contained_polygon_is_hole(contained_polygon)

func _update_contained_polygon_is_hole(contained_polygon: StackedPolygon) -> void:
	contained_polygon.is_hole = not is_hole
	if contained_polygon is StackedPolygonContainer:
		contained_polygon.update_contained_polygons_is_hole()
