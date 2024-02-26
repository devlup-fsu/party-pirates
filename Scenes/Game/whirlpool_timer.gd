extends Timer

@export var water_node: Node
@export var whirlpool_x: int
@export var whirlpool_y: int

var _whirlpool_scene = load("res://Entities/Whirlpool/whirlpool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start(1)


func _on_timeout():
	var whirlpool_size = 1
	var whirlpool = _whirlpool_scene.instantiate()
	whirlpool.done.connect(done)
	whirlpool.whirlpool_radius = whirlpool_size
	whirlpool_x = 100
	whirlpool_y = 100
	#Needs to change the shaders location too
	#whirlpool.position =  Vector2(whirlpool_x, whirlpool_y)
	add_child(whirlpool)
	water_node.material.set_shader_parameter("Whirlpool_Scale", whirlpool_size)
	start(randi_range(30, 60))
	
func done():
	water_node.material.set_shader_parameter("Whirlpool_Scale", 0.0)
