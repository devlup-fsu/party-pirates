class_name PickupSpawner extends Node2D

@export var wait_time: float = 3.0
@export_range(0, 1) var powerup_chance: float = 0.05
@export_range(0, 10) var max_spawned_at_once: int = 3
## The number of pickups that should be spawned at the start of the game.
@export var spawn_at_start: int = 3
@export var treasure: Array[Treasure] = []
@export var powerups: Array[Powerup] = []

@onready var spawn_timer: Timer = $SpawnTimer

var _dropped_pickup_scene: PackedScene = load("res://Entities/DroppedPickup/dropped_pickup.tscn")
var _spawn_markers: Array[Marker2D] = []
## Keeps track of DroppedPickups that haven't yet been picked up.
## Used to determine whether to spawn another pickup with max_spawned_at_once
var _dropped_pickups: Array[DroppedPickup] = []


func _ready() -> void:
	spawn_timer.wait_time = wait_time
	
	assert(treasure.size() > 0, "PickupSpawner must have at least one treasure.")
	assert(powerups.size() > 0, "PickupSpawner must have at least one powerup.")
	
	for child in get_children():
		if child is Marker2D:
			_spawn_markers.append(child)
	
	assert(_spawn_markers.size() > 0, "PickupSpawner must have at least one Marker2D as a child.")
	
	for i in range(spawn_at_start):
		try_spawn_pickup()


func try_spawn_pickup() -> void:
	if _dropped_pickups.size() >= max_spawned_at_once:
		return
	
	var pickup_global_pos = _spawn_markers.pick_random().global_position
	for dropped_pickup in _dropped_pickups:
		if dropped_pickup.global_position == pickup_global_pos:
			return
	
	var pickup: Pickup
	if randf() <= powerup_chance and powerup_chance > 0:
		pickup = powerups.pick_random()
	else:
		pickup = treasure.pick_random()
	
	var dropped_pickup: DroppedPickup = _dropped_pickup_scene.instantiate()
	dropped_pickup.pickup = pickup
	dropped_pickup.global_position = pickup_global_pos
	add_sibling.call_deferred(dropped_pickup)
	
	_dropped_pickups.append(dropped_pickup)
	dropped_pickup.picked_up.connect(_on_dropped_pickup_picked_up)


func _on_spawn_timer_timeout() -> void:
	try_spawn_pickup()


func _on_dropped_pickup_picked_up(dropped_pickup: DroppedPickup) -> void:
	_dropped_pickups.erase(dropped_pickup)
