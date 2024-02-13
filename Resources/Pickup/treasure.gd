class_name Treasure
extends Pickup

@export var value: int = 1


func apply(player: Player) -> void:
	print("Applying treasure on player ", player.player)
