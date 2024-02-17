class_name TreasureTrail extends Node2D

## The distance needed for the tail to begin following.
@export var following_distance: int = 50
## The speed at which the treasure moves. Higher values are clunky.
@export_range(0, 10.0) var follow_speed = 4.0
## A follower will move towards the location of the previous (or earlier) follower, but not exactly;
## Rather than targetting its exact position, it will go slightly behind.
@export var lag_behind_factor: int = 50
## The distance between nodes in the tail. Note that the constant LAG_BEHIND_FACTOR also affects it.
@export var tail_padding := 20

@onready var _player: Player = get_parent()

var _dropped_pickup_scene: PackedScene = load("res://Entities/DroppedPickup/dropped_pickup.tscn")
var _trail: Array[TrailingTreasure] = []


func _ready() -> void:
	assert(_player is Player, "Parent of TreasureTrail must be of type Player.")


func _physics_process(delta: float) -> void:
	if _trail.is_empty():
		return
	
	if _trail[0].internal_pos.distance_to(_player.internal_pos) < following_distance + tail_padding:
		return
	
	var direction: Vector2 = _player.velocity.normalized() * delta
	direction *= -lag_behind_factor
	
	# Move the first treasure closer to the player.
	_trail[0].internal_pos = direction + _trail[0].internal_pos.lerp(_player.internal_pos, follow_speed * delta)
	
	# Move the rest of the treasure to the previous treasure.
	for i in range(1, _trail.size()):
		var previous := _trail[i - 1]
		var current := _trail[i]
		if previous.internal_pos.distance_to(current.internal_pos) >= tail_padding:
			current.internal_pos = direction + current.internal_pos.lerp(previous.internal_pos, follow_speed * delta)


func append(treasure: Treasure) -> void:
	var trailing = TrailingTreasure.new(treasure, _player.internal_pos)
	add_child(trailing)
	_trail.append(trailing)


func drop() -> void:
	for trailing in _trail:
		var dropped_pickup = _dropped_pickup_scene.instantiate()
		dropped_pickup.pickup = trailing.treasure
		dropped_pickup.global_position = trailing.global_position
		get_parent().add_sibling(dropped_pickup)
		trailing.queue_free()
	
	_trail.clear()


func score() -> int:
	var value = 0
	
	for trailing in _trail:
		value += trailing.treasure.value
		trailing.queue_free()
	
	_trail.clear()
	
	return value


class TrailingTreasure extends Sprite2D:
	@export var treasure: Treasure
	
	var internal_pos: Vector2
	
	var _wake_scene: PackedScene = load("res://Entities/Wake/wake.tscn")
	
	
	func _init(_treasure: Treasure = null, global_pos: Vector2 = Vector2.ZERO):
		if _treasure != null:
			treasure = _treasure
		
		internal_pos = global_pos
	
	
	func _ready():
		assert(treasure != null, "treasure must be set on TrailingTreasure")
		
		texture = treasure.texture
		
		# Have its position not be relative to the player.
		top_level = true
		
		var wake: Wake = _wake_scene.instantiate()
		wake.set_to_follow(self)
		add_child(wake)
	
	
	func _physics_process(_delta):
		global_position = ModCoord.get_modular_pos(internal_pos)
