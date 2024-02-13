class_name TreasureTrail extends Node2D

## The distance needed for the tail to begin following.
@export var following_distance: int = 50
## The speed at which the treasure moves. Higher values are clunky.
@export_range(0, 10.0) var follow_speed = 4.0
## A follower will move towards the location of the previous (or earlier) follower, but not exactly;
## Rather than targetting its exact position, it will go slightly behind.
@export var lag_behind_factor: int = 5
## The distance between nodes in the tail. Note that the constant LAG_BEHIND_FACTOR also affects it.
@export var tail_padding := 20

@onready var _player: Player = get_parent()

var _trail: Array[TrailingTreasure] = []


func _ready() -> void:
	assert(_player is Player, "Parent of TreasureTrail must be of type Player.")


func _physics_process(delta: float) -> void:
	if _trail.is_empty():
		return
	
	if _trail[0].internal_pos.distance_to(_player.internal_pos) < following_distance:
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
	
	for trailing in _trail:
		trailing.global_position = ModCoord.get_modular_pos(trailing.internal_pos)


func append(treasure: Treasure, global_pos: Vector2) -> void:
	var trailing = TrailingTreasure.new(treasure, global_pos)
	add_child(trailing)
	_trail.append(trailing)


func drop() -> void:
	pass


func score() -> void:
	pass


class TrailingTreasure extends Sprite2D:
	@export var treasure: Treasure

	var internal_pos: Vector2
	
	func _init(_treasure: Treasure = null, global_pos: Vector2 = Vector2.ZERO):
		if _treasure != null:
			treasure = _treasure
		
		internal_pos = global_pos

	func _ready():
		assert(treasure != null, "treasure must be set on TrailingTreasure")
		
		texture = treasure.texture
		
		# Have its position not be relative to the player.
		top_level = true
