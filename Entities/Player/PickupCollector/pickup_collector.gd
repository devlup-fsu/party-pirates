extends Area2D

@export var enabled: bool = true
@export var player: Player


func _ready() -> void:
	assert(player != null, "player must be set on PickupCollector")


func _on_area_entered(area: Area2D) -> void:
	if not enabled or not area is DroppedPickup:
		return
	
	area.pick_up(player)
