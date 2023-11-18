extends Area2D

@export var player_id := 0


func _on_player_entered(player: Player):
	if player.player == player_id:
		player.store_treasure()
