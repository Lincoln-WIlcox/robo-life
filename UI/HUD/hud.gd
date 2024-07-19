class_name HUD
extends Control

const BATTERY_MESSAGE = "Batteries: "

@onready var batteries_label: Label = $VBoxContainer/BatteriesLabel
@onready var time_left_lable: Label = $VBoxContainer/TimeLabel

var time_left := Callable(func(): return 69)

var battery_quantity := 0:
	set(new_value):
		battery_quantity = new_value
		
		_update_batteries_label()

func _update_batteries_label() -> void:
	batteries_label.text = BATTERY_MESSAGE + str(battery_quantity)

func _process(_delta):
	time_left_lable.text = str(time_left.call())
