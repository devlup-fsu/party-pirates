extends Timer

var _whirlpool_scene = load("res://Entities/Whirlpool/whirlpool.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start(1)




func _on_timeout():
	var whirlpool = _whirlpool_scene.instantiate()
	whirlpool.whirlpool_radius = 500
	add_child(whirlpool)
	start(randi_range(30, 60))
