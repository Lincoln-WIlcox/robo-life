extends Node2D

@export var line_width: float = 4
@export var line_color: Color = Color(1,1,1)
@export var no_power_color: Color = Color(1,1,1)

var _redraw_queued := false

# Called when the node enters the scene tree for the first time.
func _ready():
	PowerConnectionHandler.connections_changed.connect(redraw)
	PowerConnectionHandler.connectors_state_changed.connect(redraw)
	redraw()

func redraw() -> void:
	if !_redraw_queued:
		_redraw_queued = true
		await RenderingServer.frame_post_draw
		
		for child: Node in get_children():
			if child is Line2D:
				child.queue_free()
		
		for connection: PowerConnectorConnection in PowerConnectionHandler.power_connector_connections:
			var line: Line2D = Line2D.new()
			line.add_point(connection.power_connector_a.global_position)
			line.add_point(connection.power_connector_b.global_position)
			line.width = line_width
			if connection.power_connector_a.powered:
				line.default_color = line_color
			else:
				line.default_color = no_power_color
			add_child(line)
	_redraw_queued = false
