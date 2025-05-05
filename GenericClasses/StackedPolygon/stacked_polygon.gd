class_name StackedPolygon
extends Resource

##Represents an individual polygon without contained polygons on the stack.

var _bounds: PackedVector2Array
var _hole: bool = false

func _init(init_bounds: PackedVector2Array = []):
	_bounds = init_bounds.duplicate()

func use_bounds(new_bounds: PackedVector2Array) -> void:
	_bounds = new_bounds.duplicate()
	emit_changed()

func get_bounds() -> PackedVector2Array:
	return _bounds

##Returns true if this polygon represents a hole in a container polygon.
func is_hole() -> bool:
	return _hole

##Used by containing polygon to manage if this polygon is a hole.
func update_hole(new_value: bool) -> void:
	emit_changed()
	_hole = new_value

##Converts an array of polygons to stacked polygons. Assumes there is a polygon which contains all
static func polygons_to_stacked(polygons: Array[PackedVector2Array]) -> Array[StackedPolygon]:
	var polygons_in_polygons: Dictionary = {}
	var top_polygons: Array[PackedVector2Array]
	
	for inner_polygon: PackedVector2Array in polygons:
		var within_polygons = []
		
		for outer_polygon: PackedVector2Array in polygons:
			if outer_polygon != inner_polygon and Utils.polygon_inside_polygon(outer_polygon, inner_polygon):
				within_polygons.append(outer_polygon)
				
		if within_polygons.size() == 0:
			top_polygons.append(inner_polygon)
			
		polygons_in_polygons[inner_polygon] = within_polygons
	
	var stacks: Array[StackedPolygon]
	for top_polygon: PackedVector2Array in top_polygons:
		var new_stack: StackedPolygon = _stack_inside_polygons_in_polygon(polygons_in_polygons, [top_polygon], top_polygon)
		stacks.append(new_stack)
		pass
	
	return stacks

static func _stack_inside_polygons_in_polygon(polygons_in_polygons: Dictionary, parents: Array, bounds: PackedVector2Array) -> StackedPolygon:
	var stack: StackedPolygonContainer = StackedPolygonContainer.new(bounds)
	
	for polygon: PackedVector2Array in polygons_in_polygons:
		if polygons_in_polygons[polygon] == parents:
				var new_parents = parents.duplicate()
				new_parents.append(polygon)
				var new_stack: StackedPolygon = _stack_inside_polygons_in_polygon(polygons_in_polygons, new_parents, polygon)
				stack.add_contained_polygon(new_stack)
	
	return stack
