class_name DefaultShootBehavior extends ShootBehavior

var _default_cannon_ball_scene: PackedScene = load("res://Resources/ShootBehavior/Default/default_cannon_ball.tscn")

func shoot(parent: Node, global_pos: Vector2, direction: Vector2):
	ShootBehavior.create_cannon_ball(parent, global_pos, direction, _default_cannon_ball_scene)

	SfxManager.play("cannon")
