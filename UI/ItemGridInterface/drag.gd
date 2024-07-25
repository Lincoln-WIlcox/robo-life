extends MarginContainer

signal dragged

func _gui_input(event):
	if event.is_action_pressed("drag_item"):
		dragged.emit()
