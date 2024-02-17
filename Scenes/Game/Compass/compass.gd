extends Node2D

var direction: Vector2

func v2tov3(v2: Vector2, y: float) -> Vector3:
	return Vector3(v2.x, y, v2.y)

func _process(delta: float) -> void:
	var tilt = clamp((direction.length() - 10) / 10, 0.1, 0.5)
	var look_at_v = v2tov3(direction.normalized() , -tilt )
	%compass.look_at(look_at_v)
