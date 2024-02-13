extends Node2D

@export var water_node: Node

var tot_current: Vector2
var current: Vector2
var time: float
var water_mat: Material

var value := Vector2(500, -100)
var origin := Vector2.ZERO
const head_length = 40.0
const head_angle = 0.3 #rad
var clr := Color.RED

func _ready():
	current = Vector2(-50,0)
	tot_current += current
	water_mat = water_node.material

func _process(delta):
	time += delta
	var speed = 5
	var magni = 50
	current.y = sin(time / speed) * magni
	current.x = cos(time / speed) * magni
	
	current *= clamp(sin(time) / 2 + 0.5, 0, 1)
	
	# print(current.normalized())
	value = current
	queue_redraw()
	# current = Vector2(0,10)
	tot_current += current * -delta
	water_node.material.set_shader_parameter("CurrentDirection", tot_current)

func _draw() -> void:
	draw_line(origin, value * 2, clr, 10)
	var head : Vector2 = -value.normalized() * head_length
	draw_line(value * 2, value * 2 + head.rotated(head_angle),  clr, 10)
	draw_line(value * 2, value * 2 + head.rotated(-head_angle),  clr, 10)
