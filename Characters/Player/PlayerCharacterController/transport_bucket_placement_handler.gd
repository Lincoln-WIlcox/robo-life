extends Node

@export var node_to_put_transport_buckets_in: Node

func _on_place_object_handler_placeable_placed(placeable):
	if placeable is TransportBucketPlaceable:
		placeable.place_transport_bucket_in_node(node_to_put_transport_buckets_in)
