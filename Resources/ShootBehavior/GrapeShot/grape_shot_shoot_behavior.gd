class_name GrapeShotShootBehavior extends ShootBehavior

var _default_cannon_ball_scene: PackedScene = load("res://Resources/ShootBehavior/Default/default_cannon_ball.tscn")
var _grape_shot_scene: PackedScene = load("res://Resources/ShootBehavior/GrapeShot/grape_shot.tscn")


func shoot(parent: Node, global_pos: Vector2, direction: Vector2):
	ShootBehavior.create_cannon_ball(parent, global_pos, direction, _default_cannon_ball_scene)
	
	ShootBehavior.create_cannon_ball(parent, global_pos, direction.rotated(deg_to_rad(-30)), _grape_shot_scene)
	ShootBehavior.create_cannon_ball(parent, global_pos, direction.rotated(deg_to_rad(-15)), _grape_shot_scene)
	ShootBehavior.create_cannon_ball(parent, global_pos, direction.rotated(deg_to_rad(15)), _grape_shot_scene)
	ShootBehavior.create_cannon_ball(parent, global_pos, direction.rotated(deg_to_rad(30)), _grape_shot_scene)
