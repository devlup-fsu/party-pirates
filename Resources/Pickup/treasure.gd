class_name Treasure extends Pickup

@export var value: int = 1


func pick_up(player: Player) -> void:
	player.add_treasure_to_trail(self)
