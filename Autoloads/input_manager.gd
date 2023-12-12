extends Node

class InputProxy:
	var gamepad_id: int
	const DEADZONE = 0.25
	
	
	func _init(_gamepad_id: int):
		self.gamepad_id = _gamepad_id
	
	
	func get_turning() -> float:
		if self.gamepad_id == -1 or self.gamepad_id == -2:
			var leftKey := KEY_A if self.gamepad_id == -1 else KEY_LEFT
			var rightKey := KEY_D if self.gamepad_id == -1 else KEY_RIGHT
			
			var ret := 0
			if Input.is_physical_key_pressed(leftKey):
				ret -= 1
			if Input.is_physical_key_pressed(rightKey):
				ret += 1
			
			return ret
		else:
			var ret := Input.get_joy_axis(self.gamepad_id, JOY_AXIS_LEFT_X)
			if abs(ret) < DEADZONE:
				ret = 0
			return ret
	
	
	func is_shoot_left_pressed() -> bool:
		if self.gamepad_id == -1 or self.gamepad_id == -2:
			var key := KEY_W if self.gamepad_id == -1 else KEY_UP
			return Input.is_physical_key_pressed(key)
		else:
			return Input.get_joy_axis(self.gamepad_id, JOY_AXIS_TRIGGER_LEFT) > 0.75
	
	
	func is_shoot_right_pressed() -> bool:
		if self.gamepad_id == -1 or self.gamepad_id == -2:
			var key := KEY_S if self.gamepad_id == -1 else KEY_DOWN
			return Input.is_physical_key_pressed(key)
		else:
			return Input.get_joy_axis(self.gamepad_id, JOY_AXIS_TRIGGER_RIGHT) > 0.75

	func is_move_left_pressed() -> bool:
		if self.gamepad_id == -1 or self.gamepad_id == -2:
			var key := KEY_W if self.gamepad_id == -1 else KEY_UP
			return Input.is_physical_key_pressed(key)
		else:
			return Input.is_joy_button_pressed(self.gamepad_id, JOY_BUTTON_LEFT_SHOULDER)
	
	
	func is_move_right_pressed() -> bool:
		if self.gamepad_id == -1 or self.gamepad_id == -2:
			var key := KEY_S if self.gamepad_id == -1 else KEY_DOWN
			return Input.is_physical_key_pressed(key)
		else:
			return Input.is_joy_button_pressed(self.gamepad_id, JOY_BUTTON_RIGHT_SHOULDER)
	
	func get_move_vector() -> Vector2:
		if self.gamepad_id >= 0:
			var x = Input.get_joy_axis(self.gamepad_id, JOY_AXIS_LEFT_X)
			var y = Input.get_joy_axis(self.gamepad_id, JOY_AXIS_LEFT_Y)
			var direction = Vector2(x, y)
			if (abs(direction.length()) < 0.75):
				return Vector2()
			else:
				return direction.normalized()
		
		# TODO: Keyboard support
		return Vector2()
	
	func get_shoot_vector() -> Vector2:
		if self.gamepad_id >= 0:
			var x = Input.get_joy_axis(self.gamepad_id, JOY_AXIS_RIGHT_X)
			var y = Input.get_joy_axis(self.gamepad_id, JOY_AXIS_RIGHT_Y)
			var direction = Vector2(x, y)
			if (abs(direction.length()) < 0.75):
				return Vector2()
			else:
				return direction.normalized()
		
		# TODO: Keyboard support
		return Vector2()


var gamepads: Array[InputProxy] = []
var game_started := false


func _ready() -> void:
	for gamepad_id in Input.get_connected_joypads():
		self.gamepads.push_back(InputProxy.new(gamepad_id))
	
	# Add keyboard users if we don't have enough players
	if self.gamepads.size() < 1:
		self.gamepads.push_back(InputProxy.new(-1))
	if self.gamepads.size() < 2:
		self.gamepads.push_back(InputProxy.new(-2))
	
	Input.joy_connection_changed.connect(self.joy_connection_changed)


func joy_connection_changed(gamepad_id: int, connected: bool) -> void:
	if self.game_started:
		return
	
	if connected:
		# Connection: We want to prioritize giving keyboard players a gamepad first
		# First though, make sure isn't already connected (working around a weird thing that happens
		# when a gamepad is connected when the game starts)
		for gamepad_ in self.gamepads:
			var gamepad = gamepad_ as InputProxy
			if gamepad.gamepad_id == gamepad_id:
				return
		
		var assigned := false
		for gamepad_ in self.gamepads:
			var gamepad = gamepad_ as InputProxy
			if !assigned and (gamepad.gamepad_id == -1 or gamepad.gamepad_id == -2):
				print("Assigned to gamepad " + str(gamepad.gamepad_id))
				gamepad.gamepad_id = gamepad_id
				assigned = true
				break
		
		if !assigned:
			print("Adding gamepad " + str(gamepad_id))
			self.gamepads.push_back(InputProxy.new(gamepad_id))
	else:
		# Disconnect
		# Find the index of the corresponding gamepad
		var index := 0
		for gamepad_ in self.gamepads:
			var gamepad = gamepad_ as InputProxy
			if gamepad.gamepad_id == gamepad_id:
				break
			index += 1
		
		# Check if we have player 2 using a keyboard
		var has_p2_keyboard := false
		for gamepad_ in self.gamepads:
			var gamepad = gamepad_ as InputProxy
			if gamepad.gamepad_id == -2:
				has_p2_keyboard = true
				break
		
		# Do disconnection
		print("Disconnecting gamepad " + str(gamepad_id))
		if self.gamepads.size() <= 2:
			# Reset a player back to keyboard if necessary
			if has_p2_keyboard:
				self.gamepads[index].gamepad_id = -1
			else:
				self.gamepads[index].gamepad_id = -2
		else:
			# Remove the corresponding gamepad
			self.gamepads.remove_at(index)


# Returns the number of players, including keyboard users.
func get_player_count() -> int:
	return self.gamepads.size()


# Returns the number of connected controllers, not keyboards.
func get_connected_count() -> int:
	var count := 0
	for gamepad_ in self.gamepads:
		var gamepad = gamepad_ as InputProxy
		if gamepad.gamepad_id != -1 and gamepad.gamepad_id != -2:
			count += 1
	
	return count


func get_gamepad(index: int) -> InputProxy:
	return self.gamepads[index] as InputProxy
