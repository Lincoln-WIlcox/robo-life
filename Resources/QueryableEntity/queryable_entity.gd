class_name QueryableEntity
extends Resource

var source_node: Node

signal source_disconnected

func connect_source(source: Node) -> void:
	source_node = source
	source_node.tree_exiting.connect(_on_source_node_tree_exiting)

func disconnect_source() -> void:
	source_node = null
	source_disconnected.emit()

func _on_source_node_tree_exiting() -> void:
	source_disconnected.emit()
