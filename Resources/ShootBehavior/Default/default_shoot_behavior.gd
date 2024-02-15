class_name DefaultShootBehavior extends ShootBehavior

var _default_cannon_ball_scene: PackedScene = load("res://Resources/ShootBehavior/Default/default_cannon_ball.tscn")

func shoot(parent: Node, global_pos: Vector2, direction: Vector2):
	var cannon_ball = _default_cannon_ball_scene.instantiate()
	cannon_ball.direction = direction
	cannon_ball.global_position = global_pos
	parent.add_child(cannon_ball)
