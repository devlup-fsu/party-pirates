class_name Player
extends CharacterBody2D

const MAX_SPEED = 300.0
const TURN_SPEED = deg_to_rad(90)

@export var player = 0

@onready var treasure_collector: TreasureCollector = $TreasureCollector

var speed: float = 0


func _ready() -> void:
	$AnimatedSprite2D.play("player" + str(self.player))


func _physics_process(delta: float) -> void:
	# TODO: Add support for multiple players
	var input := InputManager.get_gamepad(player)
	
	var input_dir := Vector2()
	input_dir.x = input.get_turning()
	input_dir.y = 1
	
	speed = velocity.length()
	speed = clamp((input_dir.y * 30) + (speed), 0, MAX_SPEED)
	
	var target := Vector2(cos(rotation), sin(rotation)).rotated(input_dir.x * TURN_SPEED * delta * (1 + speed / MAX_SPEED * 24))
	var direction = lerp(target, velocity.normalized(), speed / MAX_SPEED * 0.9)
	
	if input_dir:
		velocity = direction * speed
		look_at(global_position + direction)    # Rotate the player to face the direction they are moving.

	move_and_collide(velocity * delta)


func _process(_delta: float):
	# Temporary code for sending held treasure to the scoreboard.
	# Will eventually be called instead when you reach your base.
	if Input.is_action_just_pressed("ui_text_submit"):
		store_treasure()


func store_treasure() -> void:
	var score = treasure_collector.empty_treasure()
	Scores.add_player_score(player, score)
