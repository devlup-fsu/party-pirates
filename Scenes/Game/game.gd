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
		player.cannon_parent = $CannonParent
		add_child(player)
		player.global_position = $SpawnPoints.get_child( i ).global_position


func _on_timer_timeout():
	time -= 1
	SCORE_BOARD.update_time(time)
	
	if time <= 0:
		get_tree().paused = true


func _on_treasure_spawner_spawn_requested(position, to_spawn):
	# Checking if treasure already exists in that position, and if yes we stop.
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	var nodes_at_point = get_world_2d().direct_space_state.intersect_point(query)
	for i in nodes_at_point:
		if (i["collider"] is Treasure):
			print("Game: Denied treasure spawn. Reason: Treasure already exists in that location.")
			return
	
	to_spawn.global_position = position
	add_child(to_spawn)
