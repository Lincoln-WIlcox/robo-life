extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play("Dust")

func _on_animation_finished():
	queue_free()
