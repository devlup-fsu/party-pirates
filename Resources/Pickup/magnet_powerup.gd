class_name MagnetPowerup extends Powerup


func apply(player: Player) -> void:
	player.pickup_collector.set_radius_multiplier(2)


func remove(player: Player) -> void:
	player.pickup_collector.set_radius_multiplier(1)
