class_name TreasureSpawner
extends Node2D

## Determines how much treasure is spawned, and where. Dependent on the [spawn_markers] array.
enum SpawnStrategy {
	## Each call to spawn() will place the newly created treasure in the next Marker2D's location,
	## as found in the [spawn_markers] array.
	Sequential,
	## Each call to spawn() will place the newly created treasure in a random Marker2D's location.
	Random,
	## Treasure will be spawned for every Marker2D in [spawn_markers]. Each Treasure will be in their
	## respective Marker2D's position.
	All
}

@export var spawn_strategy: SpawnStrategy = SpawnStrategy.Random
@export var is_timed := true
@export var wait_time := 3
## The maximum number of treasure that is allowed spawned at once without.
## being picked up. Set to 0 to not have a maximum.
@export_range(0, 10) var max_spawned_at_once := 3
## The maximum number of treasure that is allowed on the screen at once.
## Set to 0 to not have a maximum.
@export_range(0, 10) var max_on_screen_at_once := 5

@onready var spawn_timer: Timer = $SpawnTimer
@onready var treasure_scene: PackedScene = preload("res://Entities/Treasure/treasure.tscn")
@onready var spawn_markers: Array[Marker2D]

## Used with TreasureSpawnerStrategy.Sequential to track which is next.
var index := 0
## Used to keep track of treasure that was spawned at a point and not yet moved
## so that more treasure doesn't spawn at that spot.
var blocking_treasure: Array[Treasure] = []
## Used to keep track of how many treasure have been spawned that are still on the board.
var treasure_spawned := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Marker2D:
			spawn_markers.append(child)
	
	assert(spawn_markers.size() > 0, "TreasureSpawner: Add Marker2D children or set spawn_strategy to Self")
	
	spawn_timer.wait_time = wait_time
	
	if is_timed:
		spawn_timer.start()


func enable_timer() -> void:
	spawn_timer.start()


func disable_timer() -> void:
	spawn_timer.stop()


func _on_spawn_timer_timeout():
	spawn_treasure(1)


## Will spawn treasure according to [spawn_strategy]
## Note that TreasureSpawnerStrategy.All will ignore [count]
func spawn_treasure(count: int) -> void:
	match spawn_strategy:
		SpawnStrategy.Sequential:
			_spawn_sequential(count)
		SpawnStrategy.Random:
			_spawn_random(count)
		SpawnStrategy.All:
			_spawn_all()
		_:
			assert(false, "TreasureSpawner: Unknown spawn strategy")


func _spawn_sequential(count: int) -> void:
	for i in range(count):
		var selected_marker: Marker2D = spawn_markers[index % spawn_markers.size()]
		
		_try_spawn(selected_marker.global_position)


func _spawn_random(count: int) -> void:
	for i in range(count):
		for j in range(10):
			var selected_marker: Marker2D = spawn_markers.pick_random()
			
			if _try_spawn(selected_marker.global_position):
				break


func _spawn_all() -> void:
	for i in range(spawn_markers.size()):
		var selected_marker: Marker2D = spawn_markers[i]
		
		_try_spawn(selected_marker.global_position)


func _try_spawn(global_pos: Vector2) -> bool:
	if treasure_spawned >= max_on_screen_at_once:
		return false
	
	if blocking_treasure.size() >= max_spawned_at_once:
		return false
	
	for treasure in blocking_treasure:
		if treasure.global_position == global_pos:
			return false
	
	var new_treasure: Treasure = treasure_scene.instantiate()
	
	add_sibling(new_treasure)
	new_treasure.global_position = global_pos
	new_treasure.collected.connect(_on_treasure_collected)
	new_treasure.scored.connect(_on_treasure_scored)
	
	blocking_treasure.push_back(new_treasure)
	treasure_spawned += 1
	
	return true


func _on_treasure_collected(treasure: Treasure) -> void:
	blocking_treasure.erase(treasure)


func _on_treasure_scored(_treasure: Treasure) -> void:
	treasure_spawned -= 1
