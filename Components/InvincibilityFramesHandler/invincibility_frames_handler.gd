extends Node

@onready var timer: Timer = $Timer

@export var hurtbox: Hurtbox
@export var i_seconds := 3:
	set(new_value):
		i_seconds = new_value
		
		if is_inside_tree():
			timer.wait_time = i_seconds

signal i_frames_ended

func _ready():
	timer.wait_time = i_seconds

func on_damage_taken(_amount):
	timer.start()
	hurtbox.take_damage = false

func _on_timer_timeout():
	hurtbox.take_damage = true
	i_frames_ended.emit()
