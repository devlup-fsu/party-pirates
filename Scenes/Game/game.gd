extends Node2D

@onready var TIMER: Timer = $Timer
@onready var SCORE_BOARD = $UILayer/ScoreBoard

var PlayerScene = preload( "res://Entities/Player/player.tscn" )

# Start the timer at 3 minutes, or 60 * 3 seconds.
var time := 60 * 3

func start():
	Scores.reset()
	TIMER.start()
	InputManager.game_started = true
	
	for i in range( InputManager.get_player_count() ):
		var player := PlayerScene.instantiate() as Player
		player.player = i
		add_child( player )
		player.global_position = $SpawnPoints.get_child( i ).global_position


func _on_timer_timeout():
	time -= 1
	SCORE_BOARD.update_time(time)
	
	if time <= 0:
		get_tree().paused = true
