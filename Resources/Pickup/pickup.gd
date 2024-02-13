class_name Pickup
extends Resource

@export var texture: Texture2D


func apply(_player: Player) -> void:
	assert(false, "apply() must be overridden from Pickup")
