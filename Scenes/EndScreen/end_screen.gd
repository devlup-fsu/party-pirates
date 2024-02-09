extends Control

@onready var score0: Label = $Score0
@onready var score1: Label = $Score1
@onready var score2: Label = $Score2
@onready var score3: Label = $Score3

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
	
	score0.text = str(scores[0][1])
	score1.text = str(scores[1][1])
	score2.text = str(scores[2][1])
	score3.text = str(scores[3][1])

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/game.tscn")
	
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/StartMenu/start_menu.tscn")
