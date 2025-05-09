class_name PowerPole
extends Placeable

const MAX_CONNECTIONS_ON_PLACE = 4
const MAX_CONNECTIONS = 6

@onready var power_connector: PowerConnector = $PowerConnector
@onready var connect_area: Area2D = $ConnectArea

@export var node_to_put_lines_in: Node
@export var environment_query_system: EnvironmentQuerySystem
@export var start_placed := false
@export var power_pole_selection_texture: Texture
@export var transport_bucket_queryable: TransportBucketDestinationSelectionQueryableEntity

var _drawn_lines = []

func _ready():
	super()
	transport_bucket_queryable.connect_source(self)
	transport_bucket_queryable.power_connector = power_connector
	transport_bucket_queryable.map_entity_setup.connect(_on_transport_bucket_queryable_map_entity_setup)
	
	if environment_query_system:
		environment_query_system.add_entity_queryable(transport_bucket_queryable)
	
	#power_pole_selection_map_entity.source_node = self
	#power_pole_selection_map_entity.scene_setup.connect(_on_power_pole_selection_map_entity_setup.bind(power_pole_selection_map_entity))
	
	if start_placed:
		#for some reason you have to wait two physics frams
		await Engine.get_main_loop().physics_frame
		await Engine.get_main_loop().physics_frame
		place()

func initialize(context: PlaceableContext) -> void:
	node_to_put_lines_in = context.world
	environment_query_system = context.environment_query_system

func add_to_environment_query_system(new_environment_query_system: EnvironmentQuerySystem) -> void:
	environment_query_system = new_environment_query_system
	environment_query_system.add_entity_queryable(transport_bucket_queryable)

func _on_transport_bucket_queryable_map_entity_setup(map_entity: SelectableMapEntity) -> void:
	map_entity.instance.position = global_position
	map_entity.instance.use_texture(power_pole_selection_texture)

func _on_placed():
	super()
	var connections_to_connect_to: Array[PowerConnector] = get_connectors_to_connect_to()
	
	for power_connector_to_connect_to: PowerConnector in connections_to_connect_to:
		if _connection_unobstructed(power_connector_to_connect_to):
			power_connector.connect_to(power_connector_to_connect_to)

#TODO: optimize line drawing
func _process(_delta):
	remove_lines()
	if not _placed:
		var connections_to_connect_to := get_connectors_to_connect_to()
		
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

func get_connectors_to_connect_to() -> Array[PowerConnector]:
	var connections_to_connect_to: Array[PowerConnector]
	var connections_to_connect_to_assigner: Array[Area2D] = connect_area.get_overlapping_areas().filter(func(area: Area2D): return area is PowerConnector and area != power_connector)
	connections_to_connect_to.assign(connections_to_connect_to_assigner)
	
	var connections_to_connect_to_iterator: Array[PowerConnector] = connections_to_connect_to.duplicate()
	for connector_to_connect_to: PowerConnector in connections_to_connect_to_iterator:
		if PowerConnectionHandler.get_connection_count_for_power_connector(connector_to_connect_to) >= MAX_CONNECTIONS:
			connections_to_connect_to.erase(connector_to_connect_to)
	
	if connections_to_connect_to.size() > MAX_CONNECTIONS_ON_PLACE:
		
		var other_connections: Array[PowerConnector] = connections_to_connect_to.duplicate()
		var three_closest_connections: Array[PowerConnector] = []
		for i: int in range(MAX_CONNECTIONS_ON_PLACE):
			three_closest_connections.append(connections_to_connect_to[i])
			other_connections.erase(connections_to_connect_to[i])
		
		#if a connector is closer than any connector in three_closest_connections, it replaces that connector with the closer one
		for connector: PowerConnector in other_connections:
			for i: int in range(three_closest_connections.size()):
				if global_position.distance_to(connector.global_position) < global_position.distance_to(three_closest_connections[i].global_position):
					three_closest_connections[i] = connector
					break
		
		connections_to_connect_to = three_closest_connections
	
	return connections_to_connect_to

func _connection_unobstructed(power_connector_to_connect_to: PowerConnector) -> bool:
	var check_for_walls_raycast: RayCast2D = RayCast2D.new()
	node_to_put_lines_in.add_child(check_for_walls_raycast)
	
	check_for_walls_raycast.global_position = global_position
	check_for_walls_raycast.target_position = power_connector_to_connect_to.global_position - global_position
	
	check_for_walls_raycast.collision_mask = 0
	check_for_walls_raycast.set_collision_mask_value(1, true)
	
	check_for_walls_raycast.force_raycast_update()
	return not check_for_walls_raycast.is_colliding()
