extends Node2D

@onready var TIMER: Timer = $Timer
@onready var SCORE_BOARD = $UILayer/ScoreBoard

# Start the timer at 3 minutes, or 60 * 3 seconds.
var time := 60 * 3

func start():
	Scores.reset()
	TIMER.start()


func _on_timer_timeout():
	time -= 1
	SCORE_BOARD.update_time(time)
	
	if time <= 0:
		get_tree().paused = true
