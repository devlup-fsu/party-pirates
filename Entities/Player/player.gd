class_name Player
extends CharacterBody2D

const MAX_SPEED := 300.0
const TURN_SPEED := deg_to_rad(90)
const STUNNED_SPEED := MAX_SPEED * 0.40
const SPEED_DEGRADATION := 0.9

@export var player := 0
@export var cannon_parent : Node
@export var shoot_delay := 0.5

@onready var treasure_collector: TreasureCollector = $TreasureCollector
@onready var vulnerability_timer: Timer = $VulnerabilityTimer
@onready var left_cannon: Marker2D = $LeftCannon
@onready var left_cannon_timer: Timer = $LeftCannon/Timer
@onready var right_cannon: Marker2D = $RightCannon
@onready var right_cannon_timer: Timer = $RightCannon/Timer

var speed: float = 0
var current_speed = MAX_SPEED 


func _ready() -> void:
	$AnimatedSprite2D.play("player" + str(self.player))


func _physics_process(delta: float) -> void:
	# TODO: Add support for multiple players
	var input := InputManager.get_gamepad(player)
	
	var input_dir := Vector2()
	input_dir.x = input.get_turning()
	input_dir.y = 1
	
	speed = clamp((input_dir.y * 30) + (speed), 0, current_speed)
	
	var target := Vector2(cos(rotation), sin(rotation)).rotated(input_dir.x * TURN_SPEED * delta * (1 + speed / MAX_SPEED * 24))
	var direction = lerp(target, velocity.normalized(), speed / current_speed * 0.9)
	
	if input_dir:
		velocity = direction * speed
		look_at(global_position + direction)    # Rotate the player to face the direction they are moving.

	move_and_collide(velocity * delta)


func _process(_delta: float):
	var input: InputManager.InputProxy = InputManager.get_gamepad(player)
	
	if input.is_shoot_left_pressed():
		if left_cannon_timer.is_stopped():
			CannonBall.create(cannon_parent, left_cannon.global_position, Vector2.UP.rotated(rotation))
			left_cannon_timer.start(shoot_delay)
	
	if input.is_shoot_right_pressed():
		if right_cannon_timer.is_stopped():
			CannonBall.create(cannon_parent, right_cannon.global_position, Vector2.DOWN.rotated(rotation))
			right_cannon_timer.start(shoot_delay)


func store_treasure() -> void:
	var score = treasure_collector.empty_treasure()
	Scores.add_player_score(player, score)


func got_hit() -> void:
	treasure_collector.drop_treasure()
	current_speed = STUNNED_SPEED
	treasure_collector.disable()
	
	vulnerability_timer.start()
	await vulnerability_timer.timeout
	
	current_speed = MAX_SPEED
	treasure_collector.enable()
