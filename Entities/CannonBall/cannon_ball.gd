class_name CannonBall
extends Area2D

const CANNON_BALL_SCENE: PackedScene = preload("res://Entities/CannonBall/cannon_ball.tscn")

@export var speed := 1000.0
@export var alive_time := 5.0

var direction: Vector2 = Vector2.ZERO


static func create(parent: Node, pos: Vector2, dir: Vector2) -> void:
	var cannon_ball: CannonBall = CANNON_BALL_SCENE.instantiate() 
	parent.add_child(cannon_ball)
	cannon_ball.global_position = pos
	cannon_ball.direction = dir


func _ready() -> void:
	var despawn_timer = get_tree().create_timer(alive_time)
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)


func _physics_process(delta: float) -> void:
	position += (direction * speed * delta)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hit()
	
	if body is TileMap or body is Player:
		queue_free()


func _on_despawn_timer_timeout() -> void:
	queue_free()
