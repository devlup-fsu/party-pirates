class_name Pickup
extends Resource

@export var texture: Texture2D


func apply_to(player: Player) -> void:
	assert(false, "pick_up() must be overridden")
