class_name FloatAwayTextSpawner
extends Marker2D

@onready var between_text_spawns_timer: Timer = $BetweenTextSpawnsTimer

@export var float_away_text_packed_scene: PackedScene
@export var text := "text"

func spawn_text():
	if between_text_spawns_timer.is_stopped():
		between_text_spawns_timer.start()
		var float_away_text: FloatAwayText = float_away_text_packed_scene.instantiate()
		float_away_text.text = text
		add_child(float_away_text)
