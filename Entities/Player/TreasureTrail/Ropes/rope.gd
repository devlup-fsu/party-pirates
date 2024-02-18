# Inspired by https://www.youtube.com/watch?v=y8bi0_Fggn0
class_name Rope extends Line2D

var _wrap: bool = false
var _can_wrap: bool = true
var _to_follow: Node2D
var _to_follow_path: NodePath
var _new_rope: Rope

var _rope_scene = load( "res://Entities/Player/TreasureTrail/Ropes/rope.tscn")

func set_to_follow(to_follow: Node2D):
	_to_follow = to_follow
	_to_follow_path = to_follow.get_path()
	
	top_level = true


func _process(_delta):

	if _to_follow is TreasureTrail:
		clear_points()
		
		if _to_follow._trail.size() > 0:
			var trail = _to_follow._trail.duplicate(true)
			var follow_pos: Vector2 = _to_follow.global_position

			if _wrap:
				trail.reverse()

			follow_pos = trail[0].global_position
			if (follow_pos - _to_follow.global_position).length() > 300:
				if not _wrap and _can_wrap:
					wrap_rope()
			elif not _wrap:
				add_point(_to_follow.global_position)

			for point in trail:
				if not (follow_pos - point.global_position).length() > 300:
					add_point(point.global_position)
					follow_pos = point.global_position

			if not (follow_pos - _to_follow.global_position).length() > 300 and _wrap:
				add_point(_to_follow.global_position)

			if get_point_count() == 0 and _wrap:
				_new_rope._can_wrap = true
				queue_free()


func wrap_rope():
	if not _wrap:
		var rope: Rope = _rope_scene.instantiate()
		rope.set_to_follow(_to_follow)
		get_parent().add_child(rope)
		rope._can_wrap = false
		_new_rope = rope
		_wrap = true
