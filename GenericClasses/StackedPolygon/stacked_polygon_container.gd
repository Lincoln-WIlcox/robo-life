class_name StackedPolygonContainer
extends StackedPolygon

##A polygon on the polygon stack with polygons contained within.

var _contains_polygons: Array[StackedPolygon]

##Adds [param new_polygon] to the stack if it is contained within the container's bounds and does not overlap another contained polygon. Returns false if new_polygon fails to be added.
func add_contained_polygon(new_polygon: StackedPolygon) -> bool:
	if not Utils.polygon_inside_polygon(get_bounds(), new_polygon.get_bounds()):
		return false
	
	#makes sure polygon does not overlap with any containing polygons
	for contained_polygon: StackedPolygon in _contains_polygons:
		if Utils.polygons_overlap(contained_polygon.get_bounds(), new_polygon.get_bounds()):
			return false
	
	emit_changed()
	
	new_polygon.update_hole(not _hole)
	_contains_polygons.append(new_polygon)
	new_polygon.changed.connect(emit_changed)
	
	return true

func get_contained_polygons() -> Array[StackedPolygon]:
	return _contains_polygons

##Used by this polygon's containing polygon to manage if this polygon is a hole. Also updates its contained polygon's hole status.
func update_hole(new_value: bool) -> void:
	super(new_value)
	for contained_polygon: StackedPolygon in _contains_polygons:
		contained_polygon.update_hole(not _hole)

##Returns the polygon furthest down the stack that contains the given point. If the point is outside of this polygon's bounds, this polygon will be returned.
func get_polygon_at_point(point: Vector2) -> StackedPolygon:
	for contained_polygon: StackedPolygon in _contains_polygons:
		if Geometry2D.is_point_in_polygon(point, contained_polygon.get_bounds()):
			if contained_polygon is StackedPolygonContainer:
				return contained_polygon.get_polygon_at_point(point)
			return contained_polygon
	if Geometry2D.is_point_in_polygon(point, get_bounds()):
		return self
	return null
