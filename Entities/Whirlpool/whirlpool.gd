extends Area2D

var player_list: Array[Player] = []
#var direction: Vector2

var max_radius: int = 400
@export var whirlpool_radius: float = 1
var timeout_min = 10
var timeout_max = 20

signal done

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = whirlpool_radius*max_radius
	$whirlpool_timeout.start(randi_range(timeout_min, timeout_max))

func _process(delta):
	for player in player_list:
		player.whirlpool_pull = player.global_position.direction_to(global_position)
#
#func _draw() -> void:
	#draw_circle(Vector2(), whirlpool_radius, Color(0, 0, 1, 0.25))


func _on_whirlpool_timeout_timeout():
	done.emit()
	queue_free()
	

func _on_body_entered(body):
	if body is Player:
		player_list.append(body)


func _on_body_exited(body):
	if body is Player:
		player_list.erase(body)
		body.whirlpool_pull = Vector2(0, 0)
