extends Area2D

@export var grid_size: Vector2i:
	set(new_value):
		grid_size = new_value
		$ColorRect.size = Vector2(grid_size.x * Utils.ITEM_GRID_TILE_SIZE, grid_size.y * Utils.ITEM_GRID_TILE_SIZE)
