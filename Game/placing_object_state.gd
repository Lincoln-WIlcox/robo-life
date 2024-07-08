extends State

@export var place_object_handler: PlaceObjectHandler

func enter():
	pass

func run():
	place_object_handler.update_placing()

func exit():
	place_object_handler.stop_placing()
