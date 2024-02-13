extends Area2D

@export var enabled: bool = true

@onready var _player: Player = get_parent()


func _ready() -> void:
	assert(_player is Player, "Parent of PickupCollector must be of type Player.")


func _on_area_entered(area: Area2D) -> void:
	if not enabled or not area is DroppedPickup:
		return
	
	area.pick_up(_player)
