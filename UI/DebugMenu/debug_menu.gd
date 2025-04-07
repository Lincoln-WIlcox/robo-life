extends Control

func _ready():
	Debug.debug_menu_toggled.connect(_toggle_debug_menu)

func _toggle_debug_menu():
	visible = not visible

func _on_give_battery_pressed():
	Debug.emit_give_battery_pressed()

func _on_give_steel_pressed():
	Debug.emit_give_steel_pressed()

func _on_give_food_pressed():
	Debug.emit_give_food_pressed()

func _on_give_drill_pressed():
	Debug.emit_give_drill_pressed()

func _on_give_transport_bucket_pressed():
	Debug.emit_give_transport_bucket_pressed()

func _on_give_power_pole_pressed():
	Debug.emit_give_power_pole_pressed()
