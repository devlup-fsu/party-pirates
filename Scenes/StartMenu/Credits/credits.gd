extends Control

var credits_dict = JSON.parse_string(FileAccess.get_file_as_string("res://credits.json"))
var credits_item = preload("res://Scenes/StartMenu/Credits/credits_item.tscn")

@onready var credits_container = $CreditsContainer
@onready var thanks_label = $ThanksLabel

func _ready():
	assert(credits_dict, "Credits not valid JSON formatted")

	credits_dict.shuffle()

	for contributor in credits_dict:
		var contributor_item = credits_item.instantiate()
		contributor_item.set_labels(contributor["Name"], contributor["Role"])
		credits_container.add_child(contributor_item)
	
	remove_child(thanks_label)
	credits_container.add_child(thanks_label)

	credits_container.position.y += 200

func _process(delta):
	credits_container.position.y -= 1
	if credits_container.position.y < credits_container.size.y * -1:
		queue_free()


func _on_gui_input(event):
	if event is InputEventMouseMotion:
		return
	queue_free()
