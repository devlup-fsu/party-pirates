extends Control

var credits_dict = JSON.parse_string(FileAccess.get_file_as_string("res://credits.json"))
var credits_item: PackedScene = preload("res://Scenes/StartMenu/Credits/credits_item.tscn")

@onready var credits_container = $CreditsContainer
@onready var thanks_label = $ThanksLabel


func _ready() -> void:
	assert(credits_dict != null, "credits.json does not contain a valid JSON format")
	
	credits_dict.shuffle()
	
	for contributor in credits_dict:
		var contributor_item = credits_item.instantiate()
		contributor_item.set_labels(contributor["Name"], contributor["Role"])
		credits_container.add_child(contributor_item)
	
	remove_child(thanks_label)
	credits_container.add_child(thanks_label)
	
	credits_container.position.y += 200


func _process(_delta: float) -> void:
	credits_container.position.y -= 1
	if credits_container.position.y < credits_container.size.y * -1:
		queue_free()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	queue_free()
