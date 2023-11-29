extends Area2D

func _draw():
	draw_circle(Vector2(), $CollisionShape2D.shape.radius, Color(3/256.0,44/256.0,252/256.0, 0.25))

func _on_player_entered(player: Player):
	player.got_hit()
