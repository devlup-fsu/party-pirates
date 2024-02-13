extends Area2D

@export var player_id := 0

const player_colors: Array[Color] = [
	Color(218/256.0, 99/256.0, 87/256.0),
	Color(231/256.0, 185/256.0, 35/256.0),
	Color(111/256.0, 152/256.0, 191/256.0),
	Color(117/256.0, 188/256.0, 78/256.0)
]


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.player == player_id:
			#body.score_treasure()
			pass


func _draw() -> void:
	draw_circle(Vector2(), $CollisionShape2D.shape.radius, Color(player_colors[player_id], 0.25))
