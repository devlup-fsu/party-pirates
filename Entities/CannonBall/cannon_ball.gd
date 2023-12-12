class_name CannonBall
extends Area2D

const CANNON_BALL_SCENE: PackedScene = preload("res://Entities/CannonBall/cannon_ball.tscn")
const SPEED := 1000.0
const ALIVE_TIME := 5.0

var direction : Vector2 = Vector2.ZERO


static func create(parent: Node, pos: Vector2, dir: Vector2):
	var cannon_ball: CannonBall = CANNON_BALL_SCENE.instantiate() 
	parent.add_child(cannon_ball)
	cannon_ball.global_position = pos
	cannon_ball.direction = dir


func _ready():
	var despawnTimer = get_tree().create_timer(ALIVE_TIME)
#	despawnTimer.timeout.connect(_on_despawn_timer_timeout)


func _physics_process(delta: float):
	position+=(direction*SPEED*delta)


func _on_body_entered(body: Node2D):
	if body is Player:
		body.got_hit()
	
	if body is TileMap or body is Player:
		queue_free()


func _on_despawn_timer_timeout():
	queue_free()
