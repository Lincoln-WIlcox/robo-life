class_name Counter
extends Resource

##A resource representing a value with a minimum and maximum.

@export var value: int = 0:
	set(new_value):
		new_value = clamp(new_value, min_value, max_value)
		value = new_value
		emit_changed()
@export var min_value: int = 0:
	set(new_value):
		min_value = new_value
		value = max(value, min_value)
		emit_changed()
@export var max_value: int = 100:
	set(new_value):
		max_value = new_value
		value = min(value, max_value)
		emit_changed()

##Returns the leftover value change not added to [member value] for the case that the difference between [member value] and [member max_value] is less than [param value_change].
##If all of [param value_change] was added to [member value], returns 0.
func add_value(value_change: int) -> int:
	assert(value_change >= 0, "you should not pass negative value changes to add_value.")
	var return_value: int = max(value_change - (max_value - value), 0)
	value += value_change
	return return_value

##Returns the leftover value change not subtracted from [member value] for the case that [param value_change] is greater than [member value] minus [member min_value].
##If all of [param value_change] was subtracted from [member value], returns 0.
func subtract_value(value_change: int) -> int:
	assert(value_change >= 0, "you should not pass negative value changes to subtract_value.")
	var return_value: int = max(value_change - (value - min_value), 0)
	value -= value_change
	return return_value

##Returns true if [param value_change] can be added to [member value] without going over [member max_value]. Otherwise, returns false.
func can_add_value(value_change: int) -> bool:
	return value + value_change <= max_value

##Returns true if [param value_change] can be subtracted from [member value] without going under [member min_value]. Otherwise, returns false.
func can_subtract_value(value_change: int) -> bool:
	return value - value_change >= min_value

func value_is_max() -> bool:
	return value == max_value

func value_is_min() -> bool:
	return value == min_value

func value_as_string() -> String:
	return str(value)
