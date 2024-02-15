extends Area2D

@export var speed := 1000.0
@export var alive_time := 5.0

var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	var despawn_timer = get_tree().create_timer(alive_time)
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)


func _physics_process(delta: float) -> void:
	position += (direction * speed * delta)


func _on_body_entered(body):
	if body is Player:
		body.hit()
	
	if body is TileMap or body is Player:
		queue_free()


func _on_despawn_timer_timeout() -> void:
	queue_free()
