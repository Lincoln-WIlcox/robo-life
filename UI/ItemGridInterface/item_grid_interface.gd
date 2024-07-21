class_name ItemGridInterface
extends Control

const TILE_SIZE = 48

@onready var grid_container = $CenterContainer/GridContainer

@export var item_grid_tile_packed_scene: PackedScene
@export var item_grid: ItemGrid:
	set(new_value):
		item_grid = new_value
		update_grid()

var tiles: Array[ItemGridTile]:
	get:
		var item_grid_tiles: Array[ItemGridTile]
		var nodes = grid_container.get_children().filter(func(n: Node): return n is ItemGridTile)
		item_grid_tiles.assign(nodes)
		return item_grid_tiles

signal item_dropped

func open_gui() -> void:
	show()
	update_grid()

func close_gui() -> void:
	hide()
	remove_tiles()

func update_grid() -> void:
	remove_tiles()
	
	for y: int in range(0, item_grid.size.y):
		for x: int in range(0, item_grid.size.x):
			var grid_position = Vector2i(x,y)
			
			var found_overlapping_grid_item := false
			for grid_item: ItemGridItem in item_grid.get_grid_items():
				if grid_item.position == Vector2(grid_position):
					make_item_tile(grid_item)
					found_overlapping_grid_item = true
					break
			
			if not found_overlapping_grid_item:
				make_margin()
			
			#for tile: ItemGridTile in tiles:
				#if tile.item_grid_item.rect.has_point(grid_position):
					#make_margin()
					#break

func remove_tiles() -> void:
	for child: Node in grid_container.get_children():
		child.free()

func make_margin() -> void:
	var margin = MarginContainer.new()
	margin.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
	grid_container.add_child(margin)

func make_item_tile(grid_item: ItemGridItem) -> void:
	var item_grid_tile: ItemGridTile = item_grid_tile_packed_scene.instantiate()
	item_grid_tile.texture = grid_item.item_data.texture
	item_grid_tile.tile_size = grid_item.item_data.grid_size
	item_grid_tile.item_grid_item = grid_item
	grid_container.add_child(item_grid_tile)
