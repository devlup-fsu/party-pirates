extends Node

signal score_changed

var _scores: Array[int] = []


func get_player_score(player: int) -> int:
	return _scores[player]


func add_player_score(player: int, value: int) -> void:
	_scores[player] += value
	score_changed.emit()


func reset():
	_scores = []
	
	for i in range(4):
		_scores.append(0)
	
	score_changed.emit()
