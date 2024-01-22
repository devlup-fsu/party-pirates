extends Control

@onready var GAME_SCENE: PackedScene = preload("res://Scenes/Game/game.tscn")


func _enter_tree() -> void:
	InputManager.game_started = false


func _on_start_button_pressed() -> void:
	var game = GAME_SCENE.instantiate()
	get_tree().root.add_child(game)
	game.start()
	queue_free()
