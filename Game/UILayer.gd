extends CanvasLayer

var current_ui

func show_ui(ui: Control) -> void:
	hide_ui()
	current_ui = ui
	add_child(current_ui)

func hide_ui(free: bool = true) -> void:
	if current_ui != null and current_ui.get_parent() == self:
		remove_child(current_ui)
		if free:
			current_ui.queue_free()
