extends Control

signal paused
signal unpaused

func _on_load_button_pressed():
	SaveLoad.load_game()
	_exit_menu()

func _input(event):
	if event.is_action_pressed("pause"):
		if visible:
			_exit_menu()
		else:
			_enter_menu()

func _exit_menu() -> void:
	unpaused.emit()
	hide()

func _enter_menu() -> void:
	paused.emit()
	show()
