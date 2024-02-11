extends Line2D
class_name Wake
 
var queue : Array
@export var MAX_LENGTH : int = 100
@export var TO_FOLLOW: Node2D

var wrap = false
var to_follow_path: NodePath

var WakeScene = preload( "res://Entities/Wake/wake.tscn")

func set_to_follow(to_follow: Node2D):
	TO_FOLLOW = to_follow
	to_follow_path = TO_FOLLOW.get_path()

func _process(_delta):
	if get_node_or_null(to_follow_path) == null or wrap:
		TO_FOLLOW = self
		modulate.a *= 0.95
		if modulate.a < 0.01:
			queue_free()
	else:
		var pos = TO_FOLLOW.global_position

		queue.push_front(pos)

		if queue.size() > MAX_LENGTH:
			queue.pop_back()

		if not TO_FOLLOW == self:
			clear_points()

			for point in queue:
				add_point(point)
	# janky implem until mod coord is merged:
		# Loop around the screen.
		if pos.x <= -1100:
			wrap_wake()
		elif pos.x >= 1100:
			wrap_wake()
		if pos.y <= -580:
			wrap_wake()
		elif pos.y >= 580:
			wrap_wake()

func wrap_wake():
		var wake := WakeScene.instantiate() as Wake
		wake.set_to_follow(TO_FOLLOW)
		get_parent().add_child(wake)
		wrap = true
