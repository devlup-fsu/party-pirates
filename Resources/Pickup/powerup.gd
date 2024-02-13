class_name Powerup
extends Pickup


func apply_to(player: Player) -> void:
	print("Applied powerup to player ", player.player)


func remove_from(player: Player) -> void:
	print("Removed powerup from player ", player.player)
