extends Node2D

func _ready():
	
	var polygon_stack: StackedPolygonContainer = StackedPolygonContainer.new(
		[Vector2(50,50), Vector2(150,50), Vector2(150,150), Vector2(50,150)]
		)
	
	var contained_polygon_1: StackedPolygon = StackedPolygon.new(
		[Vector2(60,60), Vector2(70,60), Vector2(70,70), Vector2(60,70)]
	)
	polygon_stack.add_contained_polygon(contained_polygon_1)
	
	var contained_polygon_2: StackedPolygonContainer = StackedPolygonContainer.new(
		[Vector2(80,80), Vector2(90,80), Vector2(90,90), Vector2(80,90)]
	)
	
	var contained_polygon_2_polygon_1: StackedPolygon = StackedPolygon.new(
		[Vector2(81,81), Vector2(89,81), Vector2(89,83), Vector2(81,83)]
	)
	
	contained_polygon_2.add_contained_polygon(contained_polygon_2_polygon_1)
	
	polygon_stack.add_contained_polygon(contained_polygon_2)
	
	var contained_polygon_2_polygon_2: StackedPolygon = StackedPolygon.new(
		[Vector2(81,84), Vector2(89,84), Vector2(89,89), Vector2(81,89)]
	)
	
	contained_polygon_2.add_contained_polygon(contained_polygon_2_polygon_2)
	
	breakpoint
	
	var new_parent_polygon: StackedPolygonContainer = StackedPolygonContainer.new(
		[Vector2(40,40), Vector2(160,40), Vector2(160,160), Vector2(40,160)]
	)
	
	new_parent_polygon.add_contained_polygon(polygon_stack)
	
	breakpoint
