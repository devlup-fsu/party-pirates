class_name Player
extends CharacterBody2D

const MAX_SPEED := 300.0
const STUNNED_SPEED := MAX_SPEED * 0.40
const SPEED_DEGRADATION := 0.9

@export var player := 0

@onready var treasure_collector: TreasureCollector = $TreasureCollector
@onready var vulnerability_timer: Timer = $VulnerabilityTimer

var speed: float = 0
var current_speed = MAX_SPEED 

func _physics_process(_delta: float) -> void:
	# TODO: Add support for multiple players
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	speed = clamp((input_dir.length() * 30) + (speed), 0, current_speed)
	
	var direction = lerp(input_dir.normalized(), velocity.normalized(), speed / current_speed * 0.9)
	
	if input_dir:
		velocity = direction * speed
		look_at(global_position + direction)    # Rotate the player to face the direction they are moving.
	else:
		velocity *= SPEED_DEGRADATION
	
	move_and_slide()


func _process(_delta: float):
	# Temporary code for sending held treasure to the scoreboard.
	# Will eventually be called instead when you reach your base.
	if Input.is_action_just_pressed("ui_text_submit"):
		store_treasure()
	
	# Temporary code to test on hit
	if Input.is_action_just_pressed("test"):
		got_hit()


func store_treasure() -> void:
	var score = treasure_collector.empty_treasure()
	Scores.add_player_score(player, score)

func got_hit() -> void:
	treasure_collector.drop_treasure()
	current_speed = STUNNED_SPEED
	treasure_collector.is_collecting = false
	
	vulnerability_timer.start()
	await vulnerability_timer.timeout
	
	current_speed = MAX_SPEED
	treasure_collector.is_collecting = true
