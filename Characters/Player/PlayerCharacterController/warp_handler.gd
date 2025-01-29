extends Node

var player_character: CharacterBody2D

func _on_warp_shelter_selected(shelter: Shelter):
	player_character.global_position = shelter.global_position
