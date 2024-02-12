extends VBoxContainer

func set_labels(_name: String, role: String) -> void:
	$NameLabel.text = _name
	$RoleLabel.text = role
