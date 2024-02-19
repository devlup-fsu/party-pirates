class_name ShootBehavior extends Resource


func shoot(parent: Node, global_pos: Vector2, direction: Vector2):
	assert(false, "shoot() must be overridden from ShootBehavior")


static func create_cannon_ball(parent: Node, global_pos: Vector2, direction: Vector2, scene: PackedScene) -> void:
	var cannon_ball = scene.instantiate()
	cannon_ball.direction = direction
	cannon_ball.global_position = global_pos
	parent.add_child(cannon_ball)
