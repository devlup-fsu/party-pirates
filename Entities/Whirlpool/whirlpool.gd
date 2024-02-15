extends Area2D

var player_list: Array[Player] = []
#var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
#	direction = Vector2(0, 0)
	$whirlpool_timeout.start(randi_range(10, 20))

func _process(delta):
	for player in player_list:
		player.whirlpool_pull = player.global_position.direction_to(global_position)

func _draw() -> void:
	draw_circle(Vector2(), $CollisionShape2D.shape.radius, Color(0, 0, 1, 0.25))


func _on_whirlpool_timeout_timeout():
	queue_free()
	

func _on_body_entered(body):
	if body is Player:
		player_list.append(body)


func _on_body_exited(body):
	if body is Player:
		player_list.erase(body)
		body.whirlpool_pull = Vector2(0, 0)
