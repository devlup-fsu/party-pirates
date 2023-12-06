class_name CannonBall
extends Area2D
const cannon_ball_scene: PackedScene = preload("res://Entities/CannonBall/cannon_ball.tscn")
const SPEED := 1000.0

var direction : Vector2 = Vector2.ZERO


static func create(parent: Node, position: Vector2, direction: Vector2):
	var cannon_ball: CannonBall = cannon_ball_scene.instantiate() 
	parent.add_child(cannon_ball)
	cannon_ball.global_position = position
	cannon_ball.direction = direction


func _physics_process(delta: float):
	position+=(direction*SPEED*delta)


func _on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.got_hit()
		queue_free()
