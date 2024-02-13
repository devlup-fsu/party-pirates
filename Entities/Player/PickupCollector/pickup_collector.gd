class_name PickupCollector extends Area2D

@export var enabled: bool = true

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _player: Player = get_parent()
@onready var _default_radius: int = _collision_shape.shape.radius


func _ready() -> void:
	assert(_player is Player, "Parent of PickupCollector must be of type Player.")
	
	_collision_shape.shape = _collision_shape.shape.duplicate()


func _on_area_entered(area: Area2D) -> void:
	if not enabled or not area is DroppedPickup:
		return
	
	area.pick_up(_player)


func set_radius_multiplier(multiplier: float) -> void:
	_collision_shape.shape.radius = _default_radius * multiplier
