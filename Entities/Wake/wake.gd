# Inspired by https://www.youtube.com/watch?v=y8bi0_Fggn0
class_name Wake
extends Line2D

@export var max_length: int = 100

var _queue: Array = []
var _wrap = false
var _to_follow: Node2D
var _to_follow_path: NodePath

var _wake_scene = load( "res://Entities/Wake/wake.tscn")


func set_to_follow(to_follow: Node2D):
	_to_follow = to_follow
	_to_follow_path = to_follow.get_path()


func _process(_delta):
	if get_node_or_null(_to_follow_path) == null or _wrap:
		_to_follow = self
		modulate.a *= 0.95
		if modulate.a < 0.01:
			queue_free()
	else:
		var pos = _to_follow.global_position

		_queue.push_front(pos)

		if _queue.size() > max_length:
			_queue.pop_back()

		if not _to_follow == self:
			clear_points()

			for point in _queue:
				add_point(point)

		var res = ModCoord.resolution * 0.99
		
		if pos.x <= -res.x:
			_wrap_wake()
		elif pos.x >= res.x:
			_wrap_wake()
		if pos.y <= -res.y:
			_wrap_wake()
		elif pos.y >= res.y:
			_wrap_wake()


func _wrap_wake():
		var wake := _wake_scene.instantiate() as Wake
		wake.set_to_follow(_to_follow)
		get_parent().add_child(wake)
		_wrap = true
