class_name Player extends CharacterBody2D

@export var max_speed := 300.0
@export var turn_speed := deg_to_rad(90)
@export var strunned_speed := max_speed * 0.40
@export var speed_degredation := 0.9
@export var current_influence := 3.0
@export var whirlpool_influence := 300.0

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

var speed: float = 0
var current_speed: float = max_speed 
var internal_pos: Vector2

var current_manager: Node
var whirlpool_pull: Vector2 = Vector2(0, 0)


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
	move_and_collide((velocity + (current_manager.current * current_influence) + (whirlpool_pull * whirlpool_influence)) * delta )
	#move_and_collide((velocity + (current_manager.current * current_influence)) * delta )
	internal_pos += global_position - last

	global_position = ModCoord.get_modular_pos(internal_pos)


func _process(_delta: float) -> void:
	var input: InputManager.InputProxy = InputManager.get_gamepad(player)
	
	if input.is_shoot_left_pressed():
		if left_cannon_timer.is_stopped():
			CannonBall.create(cannon_ball_parent, left_cannon.global_position, Vector2.UP.rotated(rotation))
			left_cannon_timer.start(shoot_delay)
	
	if input.is_shoot_right_pressed():
		if right_cannon_timer.is_stopped():
			CannonBall.create(cannon_ball_parent, right_cannon.global_position, Vector2.DOWN.rotated(rotation))
			right_cannon_timer.start(shoot_delay)


func hit() -> void:
	treasure_trail.drop()
	current_speed = strunned_speed
	pickup_collector.enabled = false
	
	vulnerability_timer.start()
	await vulnerability_timer.timeout
	
	current_speed = max_speed
	pickup_collector.enabled = true


func score() -> void:
	Scores.add_player_score(player, treasure_trail.score())


func add_treasure_to_trail(treasure: Treasure) -> void:
	treasure_trail.append(treasure)
