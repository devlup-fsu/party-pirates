extends Timer

@export var water_node: Node
@export var whirlpool_x: int
@export var whirlpool_y: int
@export var random_timeout_min = 10
@export var random_timeout_max = 20
@export var random_spawn_min = 30
@export var random_spawn_max = 60

var _whirlpool_scene = load("res://Entities/Whirlpool/whirlpool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start(1)


func _on_timeout():
	var whirlpool_size = 1
	var whirlpool = _whirlpool_scene.instantiate()
	whirlpool.done.connect(done)
	#These set how long the whirlpool exists for (randomly choosen between the two numbers)
	whirlpool.timeout_min = random_timeout_min
	whirlpool.timeout_max = random_timeout_max
	whirlpool.whirlpool_radius = whirlpool_size
	whirlpool_x = 100
	whirlpool_y = 100
	#Needs to change the shaders location too
	#whirlpool.position =  Vector2(whirlpool_x, whirlpool_y)
	add_child(whirlpool)
	water_node.material.set_shader_parameter("Whirlpool_Scale", whirlpool_size)
	start(randi_range(random_spawn_min, random_spawn_max))
	
func done():
	water_node.material.set_shader_parameter("Whirlpool_Scale", 0.0)
