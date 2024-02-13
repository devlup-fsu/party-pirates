extends Node2D

@onready var _timer: Timer = $Timer
@onready var _score_board = $UILayer/ScoreBoard
@onready var _treasure_spawner: TreasureSpawner = $TreasureSpawner

var _player_scene = load( "res://Entities/Player/player.tscn" )
var _wake_scene = load( "res://Entities/Wake/wake.tscn")

# Start the timer at 3 minutes, or 60 * 3 seconds.
var _time: float = 60 * 3


func start():
	Scores.reset()
	_timer.start()
	InputManager.game_started = true
	
	for i in range( InputManager.get_player_count() ):
		var player := _player_scene.instantiate() as Player
		player.player = i
		player.cannon_ball_parent = $CannonBallParent
		add_child(player)
		player.global_position = $SpawnPoints.get_child( i ).global_position
	
		var wake := _wake_scene.instantiate() as Wake
		wake.set_to_follow(player)
		add_child(wake)
	
	_treasure_spawner.spawn_treasure(3)


func _on_timer_timeout():
	_time -= 1
	_score_board.update_time(_time)
	
	if _time <= 0:
		get_tree().paused = true
