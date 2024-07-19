extends Node2D

@onready var basic_enemy := $BasicEnemy

@export var player_character_controller: PlayerCharacterController
@export var world: World

# Called when the node enters the scene tree for the first time.
func _ready():
	basic_enemy.target = player_character_controller.player_character.character
	basic_enemy.node_to_put_bullets_in = world
