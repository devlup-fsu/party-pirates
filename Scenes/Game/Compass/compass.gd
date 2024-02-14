extends Node2D

var direction: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%CompassNeedleSprite.look_at(global_position + direction)
