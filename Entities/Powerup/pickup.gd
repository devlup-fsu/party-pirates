extends Area2D

@export var effect: Pickup


func _player_contacted(player: Player):
	print("Pickup - Player contacted")
	player.accept_powerup(effect)
	queue_free()
