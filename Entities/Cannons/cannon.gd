class_name Cannon
extends Area2D
const cannon_scene: PackedScene = preload("res://Entities/Cannons/cannon.tscn")
const SPEED := 1000.0

var direction : Vector2 = Vector2.ZERO

static func create(parent, position, direction):
	var cannon : Cannon = cannon_scene.instantiate() 
	parent.add_child(cannon)
	cannon.global_position = position
	cannon.direction = direction

func _physics_process(delta):
	position+=(direction*SPEED*delta)


func _on_body_entered(body):
	if body is Player:
		body.got_hit()
		queue_free()
