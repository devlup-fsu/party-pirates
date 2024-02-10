class_name Pickup
extends Resource

var target: Player = null

func _init(target: Player = null): # = null required, as otherwise it'd interfere with .instantiate() and similar methods.
	self.target = target

func set_target(player: Player) -> void:
	target = player

func apply() -> void:
	assert(false, "YOU MUST OVERRIDE THIS")


func remove() -> void:
	assert(false, "YOU MUST OVERRIDE THIS")
