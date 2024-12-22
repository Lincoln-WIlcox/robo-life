extends Node

@export var overheater: Overheater
@export var progress_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.max_value = overheater.max_heat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress_bar.value = overheater.heat
