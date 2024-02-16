class_name Player extends CharacterBody2D

@export var max_speed := 300.0
@export var turn_speed := deg_to_rad(90)
@export var strunned_speed := max_speed * 0.40
@export var speed_degredation := 0.9
@export var current_influence := 3.0

@export var player := 0
@export var cannon_ball_parent: Node
@export var shoot_delay := 0.5

@onready var pickup_collector: PickupCollector = $PickupCollector
@onready var treasure_trail: TreasureTrail = $TreasureTrail
@onready var vulnerability_timer: Timer = $VulnerabilityTimer
@onready var powerup_timer: Timer = $PowerupTimer
@onready var left_cannon: Marker2D = $LeftCannon
@onready var left_cannon_timer: Timer = $LeftCannon/Timer
@onready var right_cannon: Marker2D = $RightCannon
@onready var right_cannon_timer: Timer = $RightCannon/Timer

static var s_cannon: AudioStream = preload("res://Sounds/cannon.mp3")
static var s_pickup: AudioStream = preload("res://Sounds/pickup.mp3")
static var s_hit: AudioStream = preload("res://Sounds/hit.mp3")
static var s_impact: AudioStream = preload("res://Sounds/hit.mp3")

static var s_coins_0: AudioStream = preload("res://Sounds/coins_0.mp3")
static var s_coins_1: AudioStream = preload("res://Sounds/coins_1.mp3")
static var s_coins_2: AudioStream = preload("res://Sounds/coins_2.mp3")
static var s_coins_3: AudioStream = preload("res://Sounds/coins_3.mp3")
static var s_coins_4: AudioStream = preload("res://Sounds/coins_4.mp3")

static var coins_sounds = [[10, s_coins_4], [5, s_coins_3], [3, s_coins_2], [2, s_coins_1], [0, s_coins_0]]

var speed: float = 0
var current_speed: float = max_speed 
var internal_pos: Vector2
var is_colliding: bool = false

var current_manager: Node


func _ready() -> void:
	assert(cannon_ball_parent != null, "Player: property [cannon_parent] must not be null.")
	
	$AnimatedSprite2D.play("player" + str(self.player))
	
	internal_pos = global_position


func _physics_process(delta: float) -> void:
	var input := InputManager.get_gamepad(player)
	
	var input_dir := Vector2()
	input_dir.x = input.get_turning()
	input_dir.y = 1

	speed = clamp((input_dir.y * 30) + (speed), 0, current_speed)
	
	var target := Vector2(cos(rotation), sin(rotation)).rotated(input_dir.x * turn_speed * delta * (1 + speed / max_speed * 24))
	var direction = lerp(target, velocity.normalized(), speed / current_speed * 0.9)
	
	if input_dir:
		velocity = direction * speed
		look_at(global_position + direction)    # Rotate the player to face the direction they are moving.

	var last = global_position
	var collide = move_and_collide((velocity + current_manager.current * current_influence) * delta )
	internal_pos += global_position - last

	global_position = ModCoord.get_modular_pos(internal_pos)

	if collide is KinematicCollision2D and not collide == null:
		if not %AudioStreamPlayer2D.stream == s_impact or not is_colliding:
			is_colliding = true
			%AudioStreamPlayer2D.stream = s_impact
			%AudioStreamPlayer2D.play()
	else:
		is_colliding = false


func _process(_delta: float) -> void:
	var input: InputManager.InputProxy = InputManager.get_gamepad(player)
	
	if input.is_shoot_left_pressed():
		if left_cannon_timer.is_stopped():
			CannonBall.create(cannon_ball_parent, left_cannon.global_position, Vector2.UP.rotated(rotation))
			left_cannon_timer.start(shoot_delay)
			
			%AudioStreamPlayer2D.stream = s_cannon
			%AudioStreamPlayer2D.play()
	
	if input.is_shoot_right_pressed():
		if right_cannon_timer.is_stopped():
			CannonBall.create(cannon_ball_parent, right_cannon.global_position, Vector2.DOWN.rotated(rotation))
			right_cannon_timer.start(shoot_delay)
			
			%AudioStreamPlayer2D.stream = s_cannon
			%AudioStreamPlayer2D.play()

func hit() -> void:
	%AudioStreamPlayer2D.stream = s_hit
	%AudioStreamPlayer2D.play()
	
	treasure_trail.drop()
	current_speed = strunned_speed
	pickup_collector.enabled = false
	
	vulnerability_timer.start()
	await vulnerability_timer.timeout
	
	current_speed = max_speed
	pickup_collector.enabled = true


func score() -> void:
	var added = treasure_trail.score()
	Scores.add_player_score(player, treasure_trail.score())
	
	for list_score_sound in coins_sounds:
		if added > list_score_sound[0]:
			%AudioStreamPlayer2D.stream = list_score_sound[1]
			%AudioStreamPlayer2D.play()
			break


func add_treasure_to_trail(treasure: Treasure) -> void:
	treasure_trail.append(treasure)

	%AudioStreamPlayer2D.stream = s_pickup
	%AudioStreamPlayer2D.play()

