extends MarginContainer

var item_data
var user_interface : Control

@export var label: Label
@export var button: Button


func setup(data):
	item_data = data
	label.text = data.name
	button.text = str(data.price)


func _on_button_pressed() -> void:
	if(item_data.school_specific):
		item_data['school'] = user_interface.shop_menu.button_group.get_pressed_button().get_meta("school")
	else:
		item_data['school'] = item_data.school
	user_interface.emit_signal("buy_pressed", item_data)
