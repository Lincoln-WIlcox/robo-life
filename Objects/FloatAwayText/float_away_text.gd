class_name FloatAwayText
extends Node2D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $FloatAnimation

@export var text := "text":
	set(new_value):
		text = new_value
		
		if is_inside_tree():
			label.text = text

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Float")
	label.text = text

func _on_float_animation_animation_finished(anim_name):
	queue_free()
