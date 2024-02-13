class_name DroppedPickup
extends Area2D

signal picked_up(dropped_pickup: DroppedPickup)

@export var pickup: Pickup


func _ready() -> void:
	assert(pickup != null, "pickup must be set in DroppedPickup")
	
	$Sprite2D.texture = pickup.texture


func pick_up() -> Pickup:
	picked_up.emit(self)
	queue_free()
	return pickup
