extends Timer

@export var water_node: Node

var _whirlpool_scene = load("res://Entities/Whirlpool/whirlpool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start(1)


func _on_timeout():
	var whirlpool_size = 1
	var whirlpool = _whirlpool_scene.instantiate()
	whirlpool.done.connect(done)
	whirlpool.whirlpool_radius = whirlpool_size
	add_child(whirlpool)
	water_node.material.set_shader_parameter("Whirlpool_Scale", whirlpool_size)
	start(randi_range(30, 60))
	
func done():
	water_node.material.set_shader_parameter("Whirlpool_Scale", 0.0)
