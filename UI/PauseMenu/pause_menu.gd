extends Control

func _on_save_button_pressed():
	SaveLoad.save_game()

func _on_load_button_pressed():
	SaveLoad.load_game()
