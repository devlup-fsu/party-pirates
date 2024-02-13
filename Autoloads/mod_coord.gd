extends Node

@onready var resolution = get_viewport().get_visible_rect().size + Vector2(40, 40)

## In order to handle the looping/wrapping map system, this script implements a function
## that takes an "internal position", which is where the node would be if it had
## continued traveling in that direction, and returning an "external position",
## which is where the node is actually placed in the scene.
## 
## all nodes that loop/wrap around the map should have an internal_pos Vector2,
## and all movement code for said nodes should be performed on the internal_pos,
## and then used to set the external position: 
## 	{node}.position = ModCoord.get_modular_pos({node}.internal_pos)
func get_modular_pos(pos: Vector2):
	var res = Vector2(resolution)

	res.x *= -1 if pos.x < 0 else 1
	res.y *= -1 if pos.y > 0 else 1
	
	return Vector2(
		fmod(pos.x + res.x, res.x * 2) - res.x,
		fmod(pos.y - res.y, res.y * 2) + res.y
	)
