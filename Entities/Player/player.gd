class_name Player extends CharacterBody2D

@export var max_speed := 300.0
@export var turn_speed := deg_to_rad(90)
@export var strunned_speed := max_speed * 0.40
@export var speed_degredation := 0.9
@export var current_influence := 3.0

@export var player := 0
@export var shoot_delay := 0.5
@export var default_shoot_behavior: ShootBehavior

@onready var pickup_collector: PickupCollector = $PickupCollector
@onready var treasure_trail: TreasureTrail = $TreasureTrail
@onready var vulnerability_timer: Timer = $VulnerabilityTimer
@onready var powerup_timer: Timer = $PowerupTimer
@onready var left_cannon: Marker2D = $LeftCannon
@onready var left_cannon_timer: Timer = $LeftCannon/Timer
@onready var right_cannon: Marker2D = $RightCannon
@onready var right_cannon_timer: Timer = $RightCannon/Timer

static var coins_sounds = [[10, "coins_4"], [5, "coins_3"], [3, "coins_2"], [2, "coins_1"], [0, "coins_0"]]

var speed: float = 0
var current_speed: float = max_speed 
var internal_pos: Vector2
var is_colliding: bool = false
var shoot_behavior: ShootBehavior

var current_manager: Node


func _ready() -> void:
	$AnimatedSprite2D.play("player" + str(self.player))
	
	shoot_behavior = default_shoot_behavior
	
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

	if collide is KinematicCollision2D:
		if not is_colliding:
			is_colliding = true
			SfxManager.play("hit")
	else:
		is_colliding = false


func _process(_delta: float) -> void:
	var input: InputManager.InputProxy = InputManager.get_gamepad(player)
	
	if input.is_shoot_left_pressed() and left_cannon_timer.is_stopped():
		_shoot_cannon(left_cannon.global_position, Vector2.UP.rotated(rotation))
		left_cannon_timer.start(shoot_delay)
	
	if input.is_shoot_right_pressed() and right_cannon_timer.is_stopped():
		_shoot_cannon(right_cannon.global_position, Vector2.DOWN.rotated(rotation))
		right_cannon_timer.start(shoot_delay)


func _shoot_cannon(global_pos: Vector2, direction: Vector2) -> void:
	shoot_behavior.shoot(get_parent(), global_pos, direction)


func hit() -> void:
	SfxManager.play("hit")
	
	treasure_trail.drop()
	current_speed = strunned_speed
	pickup_collector.enabled = false
	
	vulnerability_timer.start()
	await vulnerability_timer.timeout
	
	current_speed = max_speed
	pickup_collector.enabled = true


func score() -> void:
	var added = treasure_trail.score()
	Scores.add_player_score(player, added)
	
	for list_score_sound in coins_sounds:
		if added > list_score_sound[0]:
			SfxManager.play(list_score_sound[1])
			break


func add_treasure_to_trail(treasure: Treasure) -> void:
	treasure_trail.append(treasure)
	SfxManager.play("pickup")
