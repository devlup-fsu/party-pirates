class_name PickupCollector
extends Area2D

@export_range(0,  10.0) var follow_speed =  4.0
@export var max_pickups :=  3
var collected: Array[Pickup2D] = []
var is_collecting := true

@onready var collShape: CircleShape2D = $CollisionShape2D.shape
@onready var original_radius: float = collShape.radius

var player: Player

func _ready() -> void:
	player = owner
	
	# TODO: I changed the circle shape to local to scene, which I believe would make the following useless,
	# NEEDS TESTING.
	## Create a unique shape for each instance
	#var current = $CollisionShape2D.shape
	#var uniqueShape = CircleShape2D.new()
	#uniqueShape.radius = current.radius
	#$CollisionShape2D.shape = uniqueShape
	#collShape = uniqueShape

func _on_area_entered(pickup: Pickup2D) -> void:
	if collected.size() < max_pickups:
		if pickup.is_collected or not is_collecting: return
		pickup.collect()
		collected.append(pickup)


func enable() -> void:
	is_collecting = true

func disable() -> void:
	is_collecting = false

func expand_radius(amount: int) -> void:
	collShape.radius += amount

func restore_radius() -> void:
	collShape.radius = original_radius
