class_name Powerup
extends Resource

var target: Player = null

func set_target(player: Player) -> void:
	target = player

func apply() -> void:
	assert(false, "YOU MUST OVERRIDE THIS")


func remove() -> void:
	assert(false, "YOU MUST OVERRIDE THIS")
