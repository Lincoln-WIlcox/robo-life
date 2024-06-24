class_name DetectPushingComponent
extends Node2D

signal entered_pushing_area(area: Area2D)
signal exited_pushing_area(area: Area2D)

var pushing_area: PushArea
var is_in_pushing_area:
	get:
		return pushing_area != null

var _area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Area2D:
			_area = child
			break
	
	assert(_area != null, "must include area2D as child of DetectPushingComponent")
	
	_area.area_entered.connect(_on_area_entered)
	_area.area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	if area is PushArea:
		entered_pushing_area.emit(area)
		if pushing_area == null:
			pushing_area = area

func _on_area_exited(area: Area2D):
	if area is PushArea:
		exited_pushing_area.emit(area)
		if pushing_area == area:
			var overlapping_push_areas: Array[Area2D] = _get_overlapping_push_areas()
			pushing_area = overlapping_push_areas[0] if overlapping_push_areas.size() > 0 else null

func _get_overlapping_push_areas() -> Array[Area2D]:
	return _area.get_overlapping_areas().filter(func(a): return a is PushArea)
