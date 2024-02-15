class_name Powerup extends Pickup

@export var time_active: int = 5


func pick_up(player: Player) -> void:
	# Replace any other powerup the player might have.
	player.powerup_timer.stop()
	player.powerup_timer.timeout.emit()
	
	# Apply this powerup
	apply(player)
	
	# Remove this powerup after the timer is done, or if it is stopped early.
	player.powerup_timer.start(time_active)
	await player.powerup_timer.timeout
	remove(player)


func apply(_player: Player) -> void:
	assert(false, "apply() must be overridden from Pickup")


func remove(_player: Player) -> void:
	assert(false, "remove() must be overridden from Powerup")
