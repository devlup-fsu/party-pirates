class_name Pickup
extends Resource

@export var is_powerup := true
@export var auto_delete := true
@export var appearance: SpriteFrames = null

var physical_self: Pickup2D

# = null required, as otherwise it'd interfere with .instantiate() and similar methods.
func _init(appearance: SpriteFrames = null): 
	self.appearance = appearance


func apply_to(target: Player) -> void:
	assert(false, "YOU MUST OVERRIDE THIS")


func remove_from(target: Player) -> void:
	assert(false, "YOU MUST OVERRIDE THIS")

