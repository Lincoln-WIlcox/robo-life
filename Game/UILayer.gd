extends CanvasLayer

var current_ui: Node

func show_ui(ui: Control) -> void:
	hide_ui()
	current_ui = ui
	add_child(current_ui)

func hide_ui() -> void:
	if current_ui != null and current_ui.get_parent() == self:
		remove_child(current_ui)
		current_ui = null

func get_current_ui() -> Node:
	return current_ui
