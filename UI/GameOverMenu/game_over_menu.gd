class_name GameOverMenu
extends Control

@onready var game_over_label: Label = %GameOverLabel

signal play_again_pressed

func show_menu_with_death_message(death_message: String) -> void:
	game_over_label.text = death_message
	visible = true

func _on_play_again_pressed():
	play_again_pressed.emit()
