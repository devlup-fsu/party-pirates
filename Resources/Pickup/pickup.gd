class_name Pickup
extends Resource

@export var texture: Texture2D


func apply(_player: Player, _global_pos: Vector2) -> void:
	assert(false, "apply() must be overridden from Pickup")
