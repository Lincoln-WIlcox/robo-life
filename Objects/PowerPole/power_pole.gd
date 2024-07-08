extends Placeable

@onready var power_connector: PowerConnector = $PowerConnector
@onready var connect_area: Area2D = $ConnectArea

func _ready():
	placed.connect(_on_placed)

func _on_placed():
	var connections_to_connect_to := connect_area.get_overlapping_areas().filter(func(area: Area2D): return area is PowerConnector)
	
	for power_connector_to_connect_to: PowerConnector in connections_to_connect_to:
		power_connector.connect_to(power_connector_to_connect_to)
