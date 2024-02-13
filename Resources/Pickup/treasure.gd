class_name Treasure
extends Pickup

@export var value: int = 1


func apply_to(player: Player) -> void:
	assert(false, "pick_up() must be overridden")
