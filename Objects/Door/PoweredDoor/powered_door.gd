extends Door

func _on_power_consumer_power_requirement_met():
	open()

func _on_power_consumer_power_requirement_lost():
	close()
