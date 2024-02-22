class_name DroppedPickup
extends Area2D

signal picked_up(dropped_pickup: DroppedPickup)

@export var pickup: Pickup

# range is for a suitably large random offset to bobbing per object
@onready var _time: float = RandomNumberGenerator.new().randf_range(-1000.0, 10000.0)

func _ready() -> void:
	assert(pickup != null, "pickup must be set in DroppedPickup")
	
	$Sprite2D.texture = pickup.texture


func pick_up(player: Player) -> void:
	picked_up.emit(self)
	pickup.pick_up(player)
	queue_free()


func _process(delta):
	_time += delta
	$Sprite2D.rotation = sin(_time) * 0.5
	$Sprite2D.position.y = cos(_time) * 10
