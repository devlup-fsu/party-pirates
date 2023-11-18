class_name Player
extends CharacterBody2D

const MAX_SPEED = 300.0
const SPEED_DEGRADATION = 0.9

@export var player = 0

@onready var treasure_collector: TreasureCollector = $TreasureCollector

var speed: float = 0


func _physics_process(_delta: float) -> void:
	# TODO: Add support for multiple players
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	speed = clamp((input_dir.length() * 30) + (speed), 0, MAX_SPEED)
	
	var direction = lerp(input_dir.normalized(), velocity.normalized(), speed / MAX_SPEED * 0.9)
	
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


func store_treasure() -> void:
	var score = treasure_collector.empty_treasure()
	Scores.add_player_score(player, score)
