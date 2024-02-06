extends Node

signal score_changed

var _scores: Array[int] = [0, 0, 0, 0]


func get_player_score(player: int) -> int:
	return _scores[player]

func get_player_scores() -> Array[int]:
	return _scores.duplicate()

func add_player_score(player: int, value: int) -> void:
	_scores[player] += value
	score_changed.emit()


func reset():
	_scores = [0, 0, 0 ,0]
	score_changed.emit()
