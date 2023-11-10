## This script defines a TreasureCollector node that follows a target node and leaves a trail of treasure behind it.
class_name TreasureCollector
extends Area2D

signal treasure_collected(treasure: Treasure)

## The node that the trail of treasures should follow.
@export var to_follow : Node2D
## The speed at which the treasure moves. Higher values are clunky.
@export_range(0, 10.0) var follow_speed = 4.0
## The distance needed for the tail to begin following.
@export var following_distance := 50
## The distance between nodes in the tail. Note that the constant LAG_BEHIND_FACTOR also affects it.
@export var tail_padding := 20
## If true, followers will be added upon collision with this TreasureCollector. 
@export var auto_collect_followers := true

## A follower will move towards the location of the previous (or earlier) follower, but not exactly;
## Rather than targetting its exact position, it will go slightly behind.
const LAG_BEHIND_FACTOR = 5
var followers : Array[Node2D] = []


func _ready():
	assert(to_follow != null, "TreasureCollector: property [to_follow] must not be null.")
	followers.insert(0, to_follow) # Very hacky, this is because my while loop is not properly coded.


func _on_body_entered(treasure: Treasure):
	#print("TreasureCollector: collided with treasure")
	if treasure.is_collected: return
	treasure.is_collected = true
	#print("TreasureCollector: treasure collected.")
	push_back(treasure)
	emit_signal("treasure_collected", treasure)


func _on_area_entered(area: Treasure):
	_on_body_entered(area)



func _physics_process(delta):
	if followers.is_empty(): return
	if followers.size() > 1 and followers[1].global_position.distance_to(to_follow.global_position) < following_distance: return
	
	# Direction the followed node is heading.
	var going_direction: Vector2 = to_follow.velocity.normalized() * delta
	going_direction *= -LAG_BEHIND_FACTOR
	for i in range(1, followers.size()):
		var previous := followers[i - 1]
		var current := followers[i]
		if previous.global_position.distance_to(current.global_position) >= tail_padding:
			current.global_position = going_direction + current.global_position.lerp(previous.global_position, follow_speed * delta)


func insert(i: int, node: Node2D):
	followers.insert(i, node)


func push_front(node: Node2D):
	followers.push_front(node)


func push_back(node: Node2D):
	followers.push_back(node)


func pop_at(i: int):
	followers.pop_at(i)


func pop_front(node: Node2D):
	followers.pop_front()


func pop_back(node: Node2D):
	followers.pop_back()

