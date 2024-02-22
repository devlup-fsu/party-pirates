extends Node

var _num_players = 8
var _bus = "master"

var _available = []  # The available players.
var _queue = []  # The queue of sounds to play.

# stolen from:
# https://github.com/kidscancode/godot_recipes/blob/master/src-4/content/audio/audio_manager.md

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in _num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		_available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = _bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	_available.append(stream)


func play(sound_name):
	_queue.append("res://Sounds/" + sound_name + ".mp3")


func _process(delta):
	# Play a queued sound if any players are available.
	if not _queue.is_empty() and not _available.is_empty():
		_available[0].stream = load(_queue.pop_front())
		_available[0].play()
		_available.pop_front()
