class_name StackedPolygonDrawer
extends Node2D

@export var color: Color
@export var stacked_polygons: Array[StackedPolygon]:
	set(new_value):
		stacked_polygons = new_value
		for stacked_polygon: StackedPolygon in stacked_polygons:
			stacked_polygon.changed.connect(queue_redraw)

@export var _polygon_textures: Array[ImageTexture]
#polygon textures have to be cached or they will be lost when drawing instructions repeat
#var _polygon_textures: Array[ImageTexture]



func _draw():
	if stacked_polygons:
		_draw_stacked_polygons()

func _draw_stacked_polygons() -> void:
	_polygon_textures.clear()
	for stacked_polygon: StackedPolygon in stacked_polygons:
		_draw_stacked_polygon(stacked_polygon)

func _draw_stacked_polygon(stacked_polygon: StackedPolygon) -> void:
	if stacked_polygon is StackedPolygonContainer:
		if not stacked_polygon.is_hole(): 
			_draw_stacked_polygon_container(stacked_polygon)
		
		for contained_stacked_polygon: StackedPolygon in stacked_polygon.get_contained_polygons():
			_draw_stacked_polygon(contained_stacked_polygon)
	elif not stacked_polygon.is_hole():
		draw_colored_polygon(stacked_polygon.get_bounds(), color)

func _draw_stacked_polygon_container(stacked_polygon: StackedPolygonContainer) -> void:
	var holes_assigner: Array = stacked_polygon.get_contained_polygons().map(func(contained_stacked_polygon: StackedPolygon) -> PackedVector2Array: return contained_stacked_polygon.get_bounds())
	var holes: Array[PackedVector2Array]
	
	holes.assign(holes_assigner)
	
	var clipped_polygons: Array[PackedVector2Array] = Utils.clip_polygon_with_polygons(stacked_polygon.get_bounds(), holes)
	
	for clipped_polygon: PackedVector2Array in clipped_polygons:
		draw_colored_polygon(clipped_polygon, color)

#func _draw_stacked_polygon(stacked_polygon: StackedPolygon) -> void:
	##var polygon_bounding_rect_start = Time.get_ticks_usec()
	#
	#var polygon_bounding_rect: Rect2 = Utils.get_polygon_bounding_box(stacked_polygon.get_bounds())
	#
	##var polygon_bounding_rect_time = Time.get_ticks_usec() - start
	#
	##var polygon_image_start = Time.get_ticks_usec()
	#
	#var polygon_image: Image = Image.create_empty(polygon_bounding_rect.size.x, polygon_bounding_rect.size.y, true, Image.FORMAT_RGBAH)
	#
	##var polygon_image_time = Time.get_ticks_usec() - polygon_image_start
	#
	##var pixels_start = Time.get_ticks_usec()
	#
	#for pixel_x: int in range(polygon_bounding_rect.size.x):
		#for pixel_y: int in range(polygon_bounding_rect.size.y):
			#var polygon_at_point: StackedPolygon = stacked_polygon.get_polygon_at_point(Vector2(pixel_x, pixel_y) + polygon_bounding_rect.position)
			#
			#if polygon_at_point:
				#var pixel_is_hole: bool = polygon_at_point.is_hole()
				#
				#if not pixel_is_hole:
					#polygon_image.set_pixel(pixel_x, pixel_y, color)
	#
	##var pixels_time = Time.get_ticks_usec() - pixels_start
	#
	##var texture_start = Time.get_ticks_usec()
	#
	#var polygon_texture: ImageTexture = ImageTexture.new()
	#polygon_texture.set_image(polygon_image)
	#_polygon_textures.append(polygon_texture)
	#
	##var texture_time = Time.get_ticks_usec() - texture_start
	#
	##var draw_start = Time.get_ticks_usec()
	#
	#draw_texture(polygon_texture, polygon_bounding_rect.position)
	#
	##var draw_time = Time.get_ticks_usec() - draw_start
	#
	#breakpoint
