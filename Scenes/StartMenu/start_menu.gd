extends Control


func _enter_tree() -> void:
	InputManager.game_started = false


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartMenu/Credits/credits.tscn")
