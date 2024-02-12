extends Control

var start_menu_scene: PackedScene = load("res://Scenes/StartMenu/start_menu.tscn")

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_packed(start_menu_scene)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	
	get_tree().change_scene_to_packed(start_menu_scene)
