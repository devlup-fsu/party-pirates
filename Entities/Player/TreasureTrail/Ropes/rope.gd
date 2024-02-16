# Inspired by https://www.youtube.com/watch?v=y8bi0_Fggn0
class_name Rope extends Line2D

var _wrap = false
var _to_follow: Node2D
var _to_follow_path: NodePath

static var rope_scene = load( "res://Entities/Player/TreasureTrail/Ropes/rope.tscn")

func set_to_follow(to_follow: Node2D):
	_to_follow = to_follow
	_to_follow_path = to_follow.get_path()
	
	top_level = true


func _process(_delta):

	# var pos = _to_follow.global_position

	if _to_follow is TreasureTrail:
		clear_points()
		
		if not is_over(_to_follow.get_parent().internal_pos):
			add_point(_to_follow.global_position)
		else:
			add_point(_to_follow.get_parent().internal_pos)
			if not _wrap:
				wrap_rope()
			
		if _to_follow._trail.size() > 0:
			var all_over = true
			for point in _to_follow._trail:
				if not is_over(point.internal_pos):
					add_point(point.global_position)
					all_over = false
				else:
					add_point(point.internal_pos)
			if all_over:
				pass
				# queue_free()


func is_over(pos):
	var res = ModCoord.resolution * 0.9

	if pos.x <= -res.x:
		return true
	elif pos.x >= res.x:
		return true
	if pos.y <= -res.y:
		return true
	elif pos.y >= res.y:
		return true
	return false


func wrap_rope():
		var rope := load( "res://Entities/Player/TreasureTrail/Ropes/rope.tscn").instantiate() as Rope
		rope.set_to_follow(_to_follow)
		get_parent().add_child(rope)
		_wrap = true
