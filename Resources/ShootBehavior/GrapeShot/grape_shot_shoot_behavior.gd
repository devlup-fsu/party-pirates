class_name GrapeShotShootBehavior extends ShootBehavior

var _default_cannon_ball_scene: PackedScene = load("res://Resources/ShootBehavior/Default/default_cannon_ball.tscn")
var _grape_shot_scene: PackedScene = load("res://Resources/ShootBehavior/GrapeShot/grape_shot.tscn")

func create_grape(parent: Node, global_pos: Vector2, direction: Vector2, scene: PackedScene):
	var cannon_ball = scene.instantiate()
	cannon_ball.direction = direction
	cannon_ball.global_position = global_pos
	parent.add_child(cannon_ball)

func shoot(parent: Node, global_pos: Vector2, direction: Vector2):
	create_grape(parent, global_pos, direction, _default_cannon_ball_scene)
	
	create_grape(parent, global_pos, direction.rotated(deg_to_rad(-30)), _grape_shot_scene)
	create_grape(parent, global_pos, direction.rotated(deg_to_rad(-15)), _grape_shot_scene)
	create_grape(parent, global_pos, direction.rotated(deg_to_rad(15)), _grape_shot_scene)
	create_grape(parent, global_pos, direction.rotated(deg_to_rad(30)), _grape_shot_scene)
