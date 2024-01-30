extends Area2D

@export var effect: Powerup


func _player_contacted(player: Player):
	print("PowerupPickup - Player contacted")
	player.accept_powerup(effect)
	queue_free()
