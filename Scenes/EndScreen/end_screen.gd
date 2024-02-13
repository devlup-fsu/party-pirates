extends Control


func _ready() -> void:
	var scores = []
	
	for i in range(4):
		scores.append([i, Scores.get_player_score(i)])
	
	scores.sort_custom(func (a, b): return a[1] > b[1])
	
	var sprites = [$FirstPlace, $SecondPlace, $ThirdPlace, $FourthPlace]
	for i in range(scores.size()):
		sprites[i].play("player%d" % scores[i][0])
	
	$Score0.text = str(scores[0][1])
	$Score1.text = str(scores[1][1])
	$Score2.text = str(scores[2][1])
	$Score3.text = str(scores[3][1])


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartMenu/start_menu.tscn")
