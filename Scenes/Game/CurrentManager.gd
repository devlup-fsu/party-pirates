extends Node2D

@export var water_node: Node
@export var compass_node: Node

var tot_current: Vector2
var current: Vector2
var time: float
var water_mat: Material

func _ready():
	current = Vector2(-50,0)
	tot_current += current
	water_mat = water_node.material

func _process(delta):
	time += delta
	# numbers are arbitrary, bigger means slower
	var dir_speed = 10
	var gust_duration = 5
	# not this one, this one is just bigger means bigger
	var magni = 50
	current.y = sin(time / dir_speed) * magni
	current.x = cos(time / dir_speed) * magni
	current *= clamp(sin(time / gust_duration) / 2 + 0.5, 0, 1)

	tot_current += current * -delta
	water_node.material.set_shader_parameter("CurrentDirection", tot_current)

	compass_node.direction = current
