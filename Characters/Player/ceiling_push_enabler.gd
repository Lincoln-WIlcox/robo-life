extends Area2D

#The jump into ceiling separators are to push the player away from a wall as they jump if they are partially overlapping the wall.
#However, i don't want them to activate when the player jumps into a one way wall.
#This area is responsible for detecting if the player is jumping into a one way wall or a normal wall, and enableing or disableing the separators accordingly.
#To do that, all one way walls are on a separate collision layer. This area only checks for the collision layer normal walls are on.

@export var separator_left: CollisionShape2D
@export var separator_right: CollisionShape2D

func _on_body_entered(body):
	#separator_left.disabled = false
	#separator_right.disabled = false
	pass

func _on_body_exited(body):
	separator_left.disabled = true
	separator_right.disabled = true
