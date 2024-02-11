class_name Treasure
extends Pickup


var value_amount: int = 1
var physical_reference: Pickup2D

func _init(appearance: SpriteFrames = null): # = null required, as otherwise it'd interfere with .instantiate() and similar methods.
	super._init()
	self.appearance = load("res://Entities/Pickup/treasure_appearance.tres")
	is_powerup = false


func apply_to(target: Player) -> void:
	pass

func remove_from(target: Player) -> void:
	pass # Nothing to do here.
