class_name Player
extends CharacterBody2D

const MAX_SPEED = 300.0
const SPEED_DEGRADATION = 0.9

var speed: float = 0

var score := 0 : set = score_up

func _physics_process(delta) -> void:
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

func score_up(value: int) -> void:
    score += value
    print(score)
