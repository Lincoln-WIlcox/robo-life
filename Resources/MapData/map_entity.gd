class_name MapEntity
extends Resource

##Base class for map entities.
##[MapData] and [MapDisplay] are 1 to 1, but [MapEntity] and [MapData] are 1 to many.

##When this node exits the tree, the entity will be removed from map data immediately. You should set this to the root node of the scene the entity represents on that node's ready.
var source_node: Node:
	set(new_value):
		if source_node:
			source_node.tree_exiting.connect(emit_source_removed)
		source_node = new_value
		if source_node:
			source_node.tree_exiting.connect(emit_source_removed)

##Emitted when [member source_node] is freed. When emitted, it immediately removes the entity from all map datas it is in.
signal source_removed

func emit_source_removed() -> void:
	source_removed.emit()
