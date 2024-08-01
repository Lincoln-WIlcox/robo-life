extends State

@export var dragging_state: State

func _on_item_grid_interface_tile_dragged(grid_item: ItemGridItem):
	if is_current_state:
		dragging_state.grid_item = grid_item
		state_ended.emit(dragging_state)
 
