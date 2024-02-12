extends Control

var game_scene: PackedScene = load("res://Scenes/Game/game.tscn")
var credits_scene: PackedScene = load("res://Scenes/StartMenu/Credits/credits.tscn")


func _enter_tree() -> void:
	InputManager.game_started = false


func _on_start_button_pressed() -> void:
	var game = game_scene.instantiate()
	get_tree().root.add_child(game)
	game.start()
	queue_free()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(credits_scene)
