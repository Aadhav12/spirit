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
	user_interface.emit_signal("buy_pressed", item_data)
