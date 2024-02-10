class_name MagnetPowerup
extends Pickup


@export var duration: float = 7.0
@export var expansion_amount: int = 20

func apply() -> void:
	print("MagnetPowerup - APPLYING")
	var collector = target.treasure_collector
	collector.expand_radius(expansion_amount)
	await target.get_tree().create_timer(duration).timeout
	print("MagnetPowerup - WAIT ENDED")
	remove()

func remove() -> void:
	print("MagnetPowerup - REMOVING")
	target.treasure_collector.restore_radius()
