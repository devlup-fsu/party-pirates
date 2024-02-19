class_name GrapeShotPowerup extends Powerup

func apply(player: Player) -> void:
	player.shoot_behavior = GrapeShotShootBehavior.new()


func remove(player: Player) -> void:
	player.shoot_behavior = player.default_shoot_behavior
