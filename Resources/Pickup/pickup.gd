class_name Pickup extends Resource

@export var texture: Texture2D


func pick_up(_player: Player) -> void:
	assert(false, "pick_up() must be overridden from Pickup")
