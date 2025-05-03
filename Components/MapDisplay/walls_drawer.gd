extends Node

@export var walls_container: Node

var color: Color
var _polygons: Array[Polygon2D]

func draw_walls(solidity_polygons: Array[PackedVector2Array]) -> void:
	for solidity_polygon: PackedVector2Array in solidity_polygons:
		var new_polygon: Polygon2D = Polygon2D.new()
		new_polygon.polygon = solidity_polygon
		new_polygon.color = color
		_polygons.append(new_polygon)
		walls_container.add_child(new_polygon)

func clear_walls() -> void:
	for polygon: Polygon2D in _polygons:
		polygon.queue_free()
