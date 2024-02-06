extends Control

func sort_descending(a, b):
	if a[1] > b[1]:
		return true
	return false

func _ready():
	var scores = []
	for i in range(4):
		scores.append([i, Scores.get_player_score(i)])
	scores.sort_custom(sort_descending)
	var sprites = [$FirstPlace, $SecondPlace, $ThirdPlace, $FourthPlace]
	for i in range(scores.size()):
		sprites[i].play("player%d" % scores[i][0])

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/StartMenu/start_menu.tscn")
