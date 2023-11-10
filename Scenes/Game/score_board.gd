extends Control

@onready var PLAYER0_SCORE: Label = $Player0
@onready var PLAYER1_SCORE: Label = $Player1
@onready var PLAYER2_SCORE: Label = $Player2
@onready var PLAYER3_SCORE: Label = $Player3
@onready var CLOCK: Label = $Clock


func _ready():
	Scores.score_changed.connect(_on_scores_changed)


func _on_scores_changed() -> void:
	PLAYER0_SCORE.text = str(Scores.get_player_score(0))
	PLAYER1_SCORE.text = str(Scores.get_player_score(1))
	PLAYER2_SCORE.text = str(Scores.get_player_score(2))
	PLAYER3_SCORE.text = str(Scores.get_player_score(3))


func update_time(time: int) -> void:
	@warning_ignore("integer_division")
	var minutes = int(time / 60)
	var seconds = time % 60
	
	if seconds < 10:
		CLOCK.text = "%s:0%s" % [str(minutes), str(seconds)]
	else:
		CLOCK.text = "%s:%s" % [str(minutes), str(seconds)]
