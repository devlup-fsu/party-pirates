extends Node2D

@onready var _timer: Timer = $Timer
@onready var _score_board = $UILayer/ScoreBoard

var _player_scene = load( "res://Entities/Player/player.tscn" )
var _wake_scene = load( "res://Entities/Wake/wake.tscn")

# Start the timer at 3 minutes, or 60 * 3 seconds.
var _time: float = 3 * 60


func _ready() -> void:
	Scores.reset()
	_timer.start()
	InputManager.game_started = true
	
	for i in range( InputManager.get_player_count() ):
		var player := _player_scene.instantiate() as Player
		player.player = i
		player.global_position = $SpawnPoints.get_child( i ).global_position
		player.current_manager = $CurrentManager
		player.look_at(Vector2.ZERO)
		add_child(player)
	
		var wake: Wake = _wake_scene.instantiate()
		wake.set_to_follow(player)
		player.add_child(wake)


func _on_timer_timeout() -> void:
	_time -= 1
	_score_board.update_time(_time)
	
	if _time <= 0:
		get_tree().change_scene_to_file("res://Scenes/EndScreen/end_screen.tscn")
