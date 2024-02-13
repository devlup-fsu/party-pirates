class_name Treasure
extends Pickup

@export var value: int = 1


func apply(player: Player) -> void:
	player.add_treasure_to_trail(self)
