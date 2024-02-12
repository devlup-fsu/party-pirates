class_name PickupTrail
extends Node2D

@export var max_followers := 3
var followers: Array[Node2D] = []

## Appends to node trail but only if there's space.
func append(follower: Node2D) -> bool:
	if followers.size() >= max_followers: return false
	
	followers.append(follower)
	
	return true

## Removes first instance of [follower]. Returns true on success.
func remove(follower: Node2D) -> bool:
	var len = followers.size()
	followers.erase(follower)
	return len != followers.size()


func _process(delta):
	# Define a distance to maintain between the leader and followers
	var follow_distance = Vector2(0,  50)
	var leader_position = self.global_position

	for i in range(followers.size()):
		# Calculate the desired position for the follower
		var follower_desired_pos = leader_position + follow_distance.rotated(PI /  2 * i)
		
		# Move the follower towards the desired position
		followers[i].global_position = followers[i].global_position.move_toward(follower_desired_pos, delta *  100)
