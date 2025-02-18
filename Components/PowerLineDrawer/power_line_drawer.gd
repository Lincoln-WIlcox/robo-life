extends Node

@export var line_width: float = 4
@export var line_color: Color = Color(1,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	PowerConnectionHandler.connections_changed.connect(_on_connections_changed)

func _on_connections_changed():
	await RenderingServer.frame_post_draw
	
	for child: Node in get_children():
		if child is Line2D:
			child.queue_free()
	
	for connection: PowerConnectorConnection in PowerConnectionHandler.power_connector_connections:
		var line: Line2D = Line2D.new()
		line.add_point(connection.power_connector_a.global_position)
		line.add_point(connection.power_connector_b.global_position)
		line.z_index = -2
		line.width = line_width
		line.default_color = line_color
		add_child(line)
