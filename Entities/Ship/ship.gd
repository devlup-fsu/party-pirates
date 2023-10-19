extends CharacterBody2D

const MAXSPEED = 300.0
const SPEEDDEG = 0.9
const JUMP_VELOCITY = -400.0

var speed = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
    var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    speed = clamp((input_direction.length() * 30) + (speed * SPEEDDEG), 0, MAXSPEED)
    
    var direction = lerp(input_direction.normalized(), velocity.normalized(), speed / MAXSPEED * 0.9)
    
    look_at(global_position + direction)
    
    if direction:
        velocity = direction * speed
    else:
        velocity = velocity * SPEEDDEG
    # FIXME direction resets when speed hits 0

    move_and_slide()
