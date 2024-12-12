class_name PriorityQueue
extends RefCounted

##Used to process elements in order of the given priority.

var _data: Dictionary = {}

##Inserts an element into the queue.
func insert(element: Variant, priority: float) -> void:
	_data[element] = priority

##Functionally identical to [method PriorityQueue.insert], but more readable for updating purposes.
func update_priority(element: Variant, priority: float) -> void:
	insert(element, priority)

##Extracts the highest priority element from the queue.
func extract() -> Variant:
	if is_empty():
		return null
	var result: Variant = _pop_front()
	return result

func is_empty() -> bool:
	return _data.is_empty()

func _pop_front() -> Variant:
	var highest_priority_key: Variant = _data.keys().reduce(func(key: Variant, highest_priority: Variant): return key if _data[key] > _data[highest_priority] else highest_priority, _data.keys()[0])
	_data.erase(highest_priority_key)
	return highest_priority_key
