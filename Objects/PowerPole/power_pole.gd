extends Placeable

@onready var node_to_put_lines_in := get_parent()

@onready var power_connector: PowerConnector = $PowerConnector
@onready var connect_area: Area2D = $ConnectArea

var _drawn_lines = []

func _on_placed():
	var connections_to_connect_to := get_connections_to_connect_to()
	
	for power_connector_to_connect_to: PowerConnector in connections_to_connect_to:
		power_connector.connect_to(power_connector_to_connect_to)

func _process(delta):
	remove_lines()
	if not _placed:
		var connections_to_connect_to := get_connections_to_connect_to()
		
		for power_connector_to_connect_to: PowerConnector in connections_to_connect_to:
			var line = Line2D.new()
			line.add_point(global_position)
			line.add_point(power_connector_to_connect_to.global_position)
			line.modulate = Color(1,1,1,.5)
			node_to_put_lines_in.add_child(line)
			_drawn_lines.append(line)

func _exit_tree():
	remove_lines()

func remove_lines():
	for i in range(_drawn_lines.size() - 1, -1, -1):
		_drawn_lines[i].queue_free()
		_drawn_lines.remove_at(i)

func get_connections_to_connect_to() -> Array[Area2D]:
	return connect_area.get_overlapping_areas().filter(func(area: Area2D): return area is PowerConnector and area != power_connector)
